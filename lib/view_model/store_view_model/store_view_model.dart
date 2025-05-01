import 'package:coupon_admin_panel/services/image_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/repository/store_repository.dart';
import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:coupon_admin_panel/utils/form_util.dart';

import '../services/image_picker_view_model.dart';

class StoreViewModel with ChangeNotifier {
  final StoreRepository _storeRepository = StoreRepository();
  final ImageService _imageService = ImageService();

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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void selectStore(Data? store) {
    _selectedStore = store;
    if (store != null) {
      _isTopStore = store.isTopStore;
      _isEditorsChoice = store.isEditorsChoice;
      if (store.heading.isNotEmpty) {
        if (FormUtils.ALLOWED_HEADINGS.contains(store.heading)) {
          _selectedHeading = store.heading;
        }
      }
    }
    notifyListeners();
  }

  /// Reset the selected store and form state for creating a new store
  void resetSelectedStore() {
    _selectedStore = null;
    _isTopStore = false;
    _isEditorsChoice = false;
    _selectedHeading = FormUtils.ALLOWED_HEADINGS[0];
    _errorMessage = null;
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

  Future<bool> createStore(Data store, BuildContext context) async {
    if (_isSubmitting) return false;

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final imagePickerViewModel =
        Provider.of<ImagePickerViewModel>(context, listen: false);

    try {
      if (imagePickerViewModel.selectedImageBytes != null) {
        final imageUrl = await _imageService.uploadImageToS3(
          imagePickerViewModel.selectedImageBytes!,
          imagePickerViewModel.selectedImageName!,
        );
        store.image = StoreImage(url: imageUrl, alt: 'Store Image');
      }

      final response = await _storeRepository.createStore(store.toJson());

      if (response.containsKey('data') && response['data'] != null) {
        final newStore = Data.fromJson(response['data']);
        _stores.add(newStore);
        _filteredStores = List.from(_stores);
        imagePickerViewModel.clearImage();
        _errorMessage = null;
        return true;
      } else {
        _errorMessage = 'Invalid response: Store ID missing.';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error creating store: ${e.toString()}';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> updateStore(Data store, BuildContext context) async {
    if (_isSubmitting) return false;

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final imagePickerVM =
        Provider.of<ImagePickerViewModel>(context, listen: false);
    String? newImageUrl;
    final oldImageUrl = store.image.url;

    try {
      // Upload new image if selected
      if (imagePickerVM.selectedImageBytes != null) {
        newImageUrl = await _imageService.uploadImageToS3(
          imagePickerVM.selectedImageBytes!,
          imagePickerVM.selectedImageName!,
        );
        store.image = StoreImage(url: newImageUrl, alt: 'Updated Store Image');
      }

      // Update store data
      await _storeRepository.updateStore(store.toJson());

      // Delete old image only after successful update
      if (newImageUrl != null && oldImageUrl.isNotEmpty) {
        try {
          await _imageService.deleteImage(oldImageUrl);
          debugPrint('Successfully deleted old image: $oldImageUrl');
        } catch (e) {
          debugPrint('Warning: Could not delete old image: $e');
          // Consider logging this to your error tracking system
        }
      }

      // Update local state
      final index = _stores.indexWhere((s) => s.id == store.id);
      if (index != -1) {
        _stores[index] = store;
        _filteredStores = List.from(_stores);
        imagePickerVM.clearImage();
        return true;
      }

      _errorMessage = 'Store not found locally';
      return false;
    } catch (e) {
      // Cleanup newly uploaded image if update failed
      if (newImageUrl != null) {
        try {
          await _imageService.deleteImage(newImageUrl);
        } catch (deleteError) {
          debugPrint('Failed to cleanup new image: $deleteError');
        }
      }

      _errorMessage = 'Error updating store: ${e.toString()}';
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
      if (kDebugMode) print('Store deleted successfully');
    } catch (e) {
      _errorMessage = 'Error deleting store: \${e.toString()}';
      if (kDebugMode) print(_errorMessage);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // Dispose method
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
