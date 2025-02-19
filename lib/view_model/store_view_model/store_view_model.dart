import 'package:coupon_admin_panel/repository/store_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:coupon_admin_panel/model/store_model.dart';

class StoreViewModel with ChangeNotifier {
  final StoreRepository _storeRepository = StoreRepository();

  bool _isFetching = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  Data? _selectedStore;

  bool get isFetching => _isFetching;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  Data? get selectedStore => _selectedStore; // Getter for selected store

  List<Data> _stores = [];
  List<Data> _filteredStores = [];

  List<Data> get stores => _stores;
  List<Data> get filteredStores => _filteredStores;

  // Select Store for Editing
  void selectStore(Data? store) {
    _selectedStore = store;
    notifyListeners(); // Notify UI when store selection changes
  }

  // Fetch stores from repository
  Future<void> getStores() async {
    if (_stores.isNotEmpty || _isFetching) return;

    _isFetching = true;
    notifyListeners();

    try {
      final List<Data> fetchedStores = await _storeRepository.fetchStores();
      _stores = fetchedStores;
      _filteredStores =
          List.from(_stores); // Ensure filteredStores is initialized
      _errorMessage = null;

      if (kDebugMode) {
        print('Stores fetched successfully: ${_stores.length}');
      }
    } catch (e) {
      _errorMessage = 'Error fetching stores: ${e.toString()}';
      if (kDebugMode) {
        print(_errorMessage);
      }
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  // 🔹 Search Stores Method
  void searchStores(String query) {
    if (query.isEmpty) {
      _filteredStores = _stores; // Reset to full list
    } else {
      _filteredStores = _stores
          .where(
              (store) => store.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // Create a new store
  Future<void> createStore(Data store) async {
    if (_isSubmitting) return;

    _isSubmitting = true;
    notifyListeners();

    try {
      if (kDebugMode) {
        print("Creating store: ${store.toJson()}");
      }

      final Map<String, dynamic> response =
          await _storeRepository.createStore(store.toJson());

      if (response.containsKey('data') &&
          response['data'] is Map<String, dynamic> &&
          response['data']['_id'] != null &&
          response['data']['_id'].isNotEmpty) {
        final newStore = Data.fromJson(response['data']);
        _stores.add(newStore);
        _filteredStores = _stores;
        _errorMessage = null;

        if (kDebugMode) {
          print("Store created successfully: ${newStore.id}");
        }
      } else {
        throw Exception('Store ID not found in the response or empty');
      }
    } catch (e) {
      _errorMessage = 'Error creating store: ${e.toString()}';
      if (kDebugMode) {
        print(_errorMessage);
      }
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // Delete a store by its ID
  Future<void> deleteStore(String storeId) async {
    if (_isSubmitting) return;

    _isSubmitting = true;
    notifyListeners();

    try {
      await _storeRepository.deleteStore(storeId);
      _stores.removeWhere((store) => store.id == storeId);
      _filteredStores = _stores;
      _errorMessage = null;

      if (kDebugMode) {
        print('Store deleted successfully');
      }
    } catch (e) {
      _errorMessage = 'Error deleting store: ${e.toString()}';
      if (kDebugMode) {
        print(_errorMessage);
      }
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // Update a store
  Future<void> updateStore(Data store) async {
    if (_isSubmitting) return;

    _isSubmitting = true;
    notifyListeners();

    try {
      await _storeRepository.updateStore(store.toJson());
      final index = _stores.indexWhere((s) => s.id == store.id);
      if (index != -1) {
        _stores[index] = store;
        _filteredStores = _stores;
        if (kDebugMode) {
          print('Store updated successfully');
        }
      } else {
        throw Exception('Store not found');
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error updating store: ${e.toString()}';
      if (kDebugMode) {
        print(_errorMessage);
      }
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _stores.clear();
    _filteredStores.clear();
    super.dispose();
  }
}
