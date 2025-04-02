import 'package:coupon_admin_panel/repository/store_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:dio/dio.dart';

class StoreViewModel with ChangeNotifier {
  final StoreRepository _storeRepository = StoreRepository();

  bool _isFetching = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  Data? _selectedStore;
  String? _selectedHeading;

  bool get isFetching => _isFetching;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  Data? get selectedStore => _selectedStore; // Getter for selected store
  String? get selectedHeading => _selectedHeading;

  List<Data> _stores = [];
  List<Data> _filteredStores = [];

  List<Data> get stores => _stores;
  List<Data> get filteredStores => _filteredStores;

  // 🔹 Track toggle values
  bool _isTopStore = false;
  bool _isEditorsChoice = false;

  bool get isTopStore => _isTopStore;
  bool get isEditorsChoice => _isEditorsChoice;

  // 🔹 Toggle Functions
  void toggleTopStore(bool value) {
    _isTopStore = value;
    notifyListeners();
  }

  void toggleEditorsChoice(bool value) {
    _isEditorsChoice = value;
    notifyListeners();
  }

  // Select Store for Editing
  void selectStore(Data? store) {
    _selectedStore = store;
    notifyListeners(); // Notify UI when store selection changes
  }

  //selected heading
  void selectHeading(String heading) {
    _selectedHeading = heading;
    notifyListeners();
  }

  // Fetch stores from repository
  Future<void> getStores() async {
    // Step 1: Check if already loaded
    if (_stores.isNotEmpty) {
      return; // stores already loaded, no need to fetch again
    }

    _isFetching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<Data> fetchedStores = await _storeRepository.fetchStores();
      _stores = fetchedStores;
      _filteredStores = List.from(_stores);
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

  // Filter stores based on search query
  void filterStores(String query) {
    if (query.isEmpty) {
      _filteredStores = List.from(_stores);
    } else {
      final lowercaseQuery = query.toLowerCase();
      _filteredStores = _stores.where((store) {
        return store.name.toLowerCase().contains(lowercaseQuery) ||
            store.shortDescription.toLowerCase().contains(lowercaseQuery);
      }).toList();
    }
    notifyListeners();
  }

  // Search stores by name or description
  void searchStores(String query) {
    if (query.isEmpty) {
      _filteredStores = List.from(_stores);
    } else {
      final lowercaseQuery = query.toLowerCase();
      _filteredStores = _stores.where((store) {
        return store.name.toLowerCase().contains(lowercaseQuery) ||
            store.shortDescription.toLowerCase().contains(lowercaseQuery) ||
            store.longDescription.toLowerCase().contains(lowercaseQuery);
      }).toList();
    }
    notifyListeners();
  }

  // Create a new store
  Future<bool> createStore(Data store) async {
    if (_isSubmitting) return false;

    _isSubmitting = true;
    _errorMessage = null;
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
        _filteredStores =
            List.from(_stores); // Create a new list to avoid reference issues
        _errorMessage = null;

        if (kDebugMode) {
          print("Server Response: $response");
          print("Store created successfully: ${newStore.id}");
        }
        return true;
      } else {
        _errorMessage = 'Invalid server response: Store ID not found or empty';
        if (kDebugMode) {
          print("Invalid server response: $response");
        }
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error creating store: ${e.toString()}';
      if (kDebugMode) {
        print(_errorMessage);
      }
      return false;
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
  Future<bool> updateStore(Data store) async {
    if (_isSubmitting) return false;

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _storeRepository.updateStore(store.toJson());
      final index = _stores.indexWhere((s) => s.id == store.id);
      if (index != -1) {
        _stores[index] = store;
        _filteredStores =
            List.from(_stores); // Create a new list to avoid reference issues
        _errorMessage = null;

        if (kDebugMode) {
          print('Store updated successfully');
        }
        return true;
      } else {
        _errorMessage = 'Store not found in the list';
        if (kDebugMode) {
          print(_errorMessage);
        }
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error updating store: ${e.toString()}';
      if (kDebugMode) {
        print(_errorMessage);
      }
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _stores.clear();
    _filteredStores.clear();
    _selectedStore = null;
    _errorMessage = null;
    super.dispose();
  }
}
