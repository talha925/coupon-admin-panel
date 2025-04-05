import 'package:coupon_admin_panel/repository/store_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:coupon_admin_panel/utils/form_util.dart';

class StoreViewModel with ChangeNotifier {
  final StoreRepository _storeRepository = StoreRepository();

  bool _isFetching = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  Data? _selectedStore;
  String? _selectedHeading = FormUtils.ALLOWED_HEADINGS[0];

  bool get isFetching => _isFetching;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  Data? get selectedStore => _selectedStore;
  String? get selectedHeading => _selectedHeading;

  List<Data> _stores = [];
  List<Data> _filteredStores = [];

  List<Data> get stores => _stores;
  List<Data> get filteredStores => _filteredStores;

  // Toggle states
  bool _isTopStore = false;
  bool _isEditorsChoice = false;

  bool get isTopStore => _isTopStore;
  bool get isEditorsChoice => _isEditorsChoice;

  void toggleTopStore(bool value) {
    _isTopStore = value;
    notifyListeners();
  }

  void toggleEditorsChoice(bool value) {
    _isEditorsChoice = value;
    notifyListeners();
  }

  void selectStore(Data? store) {
    _selectedStore = store;
    if (store != null && store.heading.isNotEmpty) {
      if (FormUtils.ALLOWED_HEADINGS.contains(store.heading)) {
        _selectedHeading = store.heading;
      }
    }
    notifyListeners();
  }

  void selectHeading(String heading) {
    if (FormUtils.ALLOWED_HEADINGS.contains(heading)) {
      _selectedHeading = heading;
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('Warning: Attempted to set invalid heading value: $heading');
      }
    }
  }

  Future<void> getStores() async {
    if (_stores.isNotEmpty) return;

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
        print('Error fetching stores: $e');
      }
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  void filterStores(String query) {
    if (query.isEmpty) {
      _filteredStores = List.from(_stores);
    } else {
      final lowercaseQuery = query.toLowerCase();
      _filteredStores = _stores
          .where((store) =>
              store.name.toLowerCase().contains(lowercaseQuery) ||
              store.shortDescription.toLowerCase().contains(lowercaseQuery))
          .toList();
    }
    notifyListeners();
  }

  void searchStores(String query) {
    if (query.isEmpty) {
      _filteredStores = List.from(_stores);
    } else {
      final lowercaseQuery = query.toLowerCase();
      _filteredStores = _stores
          .where((store) =>
              store.name.toLowerCase().contains(lowercaseQuery) ||
              store.shortDescription.toLowerCase().contains(lowercaseQuery) ||
              store.longDescription.toLowerCase().contains(lowercaseQuery))
          .toList();
    }
    notifyListeners();
  }

  Future<bool> createStore(Data store) async {
    if (_isSubmitting) return false;

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic> response =
          await _storeRepository.createStore(store.toJson());

      if (response.containsKey('data') &&
          response['data'] is Map<String, dynamic> &&
          response['data']['_id'] != null &&
          response['data']['_id'].toString().isNotEmpty) {
        final newStore = Data.fromJson(response['data']);
        _stores.add(newStore);
        _filteredStores = List.from(_stores);
        _errorMessage = null;
        return true;
      } else {
        _errorMessage = 'Invalid response: Store ID missing.';
        if (kDebugMode) {
          print('Invalid response: $response');
        }
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error creating store: ${e.toString()}';
      if (kDebugMode) {
        print('Error creating store: $e');
      }
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> deleteStore(String storeId) async {
    if (_isSubmitting) return;

    _isSubmitting = true;
    notifyListeners();

    try {
      await _storeRepository.deleteStore(storeId);
      _stores.removeWhere((store) => store.id == storeId);
      _filteredStores = List.from(_stores);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error deleting store: ${e.toString()}';
      if (kDebugMode) {
        print('Error deleting store: $e');
      }
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

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
        _filteredStores = List.from(_stores);
        _errorMessage = null;
        return true;
      } else {
        _errorMessage = 'Store not found locally';
        if (kDebugMode) {
          print('Store not found locally');
        }
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error updating store: ${e.toString()}';
      if (kDebugMode) {
        print('Error updating store: $e');
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
    _selectedHeading = null;
    _errorMessage = null;
    super.dispose();
  }
}
