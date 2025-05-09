// ✅ Updated Coupon ViewModel with Store Filtering & Management

import 'package:flutter/foundation.dart';
import 'package:coupon_admin_panel/repository/coupon_repository.dart';
import 'package:coupon_admin_panel/model/coupon_model.dart';

class CouponViewModel with ChangeNotifier {
  final CouponRepository _couponRepository = CouponRepository();

  // Loading states
  bool _isFetching = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  // Getters
  bool get isFetching => _isFetching;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  List<CouponData> _coupons = [];
  List<CouponData> get coupons => _coupons;

  // Filter properties
  List<CouponData> _filteredCoupons = [];
  List<CouponData> get filteredCoupons => _filteredCoupons;

  // Selected coupon for editing
  CouponData? _selectedCoupon;
  CouponData? get selectedCoupon => _selectedCoupon;

  // Selected store for filtering
  String? _selectedStoreId;
  String? get selectedStoreId => _selectedStoreId;

  // Update selected coupon (for editing)
  void selectCoupon(CouponData? coupon) {
    _selectedCoupon = coupon;
    notifyListeners();
  }

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _totalPages = 0;
  int get totalPages => _totalPages;

  // Track active fetch operation
  bool _fetchInProgress = false;
  String? _lastFetchedStoreId;

  // Update selected store for filtering
  void updateSelectedStore(String? newStoreId, {bool notify = true}) {
    if (newStoreId == null || newStoreId.isEmpty) {
      print("Error: Store ID is null or empty");
      _errorMessage = 'Store ID is missing, cannot load coupons.';
    } else {
      // Only update and notify if the store ID actually changed
      if (_selectedStoreId != newStoreId) {
        _selectedStoreId = newStoreId;
        _filterCoupons(
            notify: false); // Apply filtering logic without notifying
        print('Selected Store ID: $_selectedStoreId');

        if (notify) {
          notifyListeners();
        }
      }
    }
  }

  // Optimized to handle notification control
  void _filterCoupons({bool notify = true}) {
    if (_selectedStoreId == null || _selectedStoreId!.isEmpty) {
      _filteredCoupons =
          List.from(_coupons); // Show all if no store is selected
    } else {
      _filteredCoupons = _coupons
          .where((coupon) =>
              coupon.storeId == _selectedStoreId) // Make sure storeId matches
          .toList();
    }

    if (notify) {
      notifyListeners();
    }
  }

  Future<void> fetchCouponsForStore({
    required String storeId,
    int page = 1,
    int limit = 10,
    bool updateStore = true,
  }) async {
    // Don't refetch for the same store and page if already fetching
    if (_fetchInProgress &&
        _lastFetchedStoreId == storeId &&
        _currentPage == page) {
      return;
    }

    try {
      // Update the selected store ID if requested
      if (updateStore && _selectedStoreId != storeId) {
        updateSelectedStore(storeId, notify: false); // Update without notifying
      }

      _fetchInProgress = true;
      _lastFetchedStoreId = storeId;
      _isFetching = true;
      notifyListeners();

      final response = await _couponRepository.fetchCouponsByStore(
        storeId: storeId,
        page: page,
        limit: limit,
        active: true,
        isValid: true,
      );

      // Check if this response is still relevant (no newer request has started)
      if (_lastFetchedStoreId != storeId) {
        return; // Ignore this response, as a newer request is in progress
      }

      // Always clear previous coupons before adding new ones
      _coupons.clear();
      _filteredCoupons.clear();

      final newCoupons = (response['data'] as List)
          .map((json) => CouponData.fromJson(json))
          .toList();

      _coupons.addAll(newCoupons);
      _totalPages = response['metadata']['totalPages'];
      _currentPage = page;

      print('📚 Total coupons: ${_coupons.length}');
      _filterCoupons();
    } catch (e) {
      print('Pagination error: ${e.toString()}');
      _errorMessage = 'Error fetching coupons: ${e.toString()}';
    } finally {
      _fetchInProgress = false;
      _isFetching = false;
      notifyListeners();
    }
  }

  // For Next Page
  Future<void> goToNextPage() async {
    if (_selectedStoreId == null || _selectedStoreId!.isEmpty) {
      print("Cannot paginate - no store selected");
      _errorMessage = 'Store ID is missing, cannot load coupons.';
      return;
    }

    if (_currentPage < _totalPages) {
      print(
          "Next page requested. Current page: $_currentPage, Total pages: $_totalPages");
      await fetchCouponsForStore(
        storeId: _selectedStoreId!,
        page: _currentPage + 1,
      );
    } else {
      print("Already on the last page");
    }
  }

// For Previous Page
  Future<void> goToPreviousPage() async {
    if (_selectedStoreId == null || _selectedStoreId!.isEmpty) {
      print("Cannot paginate - no store selected");
      return;
    }

    if (_currentPage > 1) {
      print("Previous page requested. Current page: $_currentPage");
      await fetchCouponsForStore(
        storeId: _selectedStoreId!,
        page: _currentPage - 1,
      );
    } else {
      print("Already on the first page.");
    }
  }

  // Fetch coupons
  Future<void> getCoupons() async {
    _isFetching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<CouponData> fetchedCoupons =
          await _couponRepository.fetchCoupons();
      _coupons = fetchedCoupons;

      // Optional: Sort featured first
      _coupons.sort((a, b) => b.featuredForHome ? 1 : -1);

      _filterCoupons();
    } catch (e) {
      _errorMessage = 'Error fetching coupons: ${e.toString()}';
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  // Create coupon
  Future<bool> createCoupon(Map<String, dynamic> couponData) async {
    // Set loading state only once at the beginning
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create the coupon
      final response = await _couponRepository.createCoupon(couponData);

      // Only add the new coupon to our list instead of fetching all coupons again
      if (response != null && response['data'] != null) {
        final newCoupon = CouponData.fromJson(response['data']);
        _coupons.add(newCoupon);
        _filterCoupons(); // Update filtered coupons list
      }

      return true;
    } catch (e) {
      _errorMessage = 'Error creating coupon: ${e.toString()}';
      return false;
    } finally {
      // Reset loading state
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // Delete coupon
  Future<bool> deleteCoupon(String couponId) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await _couponRepository.deleteCoupon(couponId);
      await getCoupons();
      return true;
    } catch (e) {
      _errorMessage = 'Error deleting coupon: ${e.toString()}';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // Update coupon
  Future<bool> updateCoupon(CouponData coupon) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _couponRepository.updateCoupon(coupon.toJson());
      if (response != null && response['status'] == 'success') {
        await getCoupons();
        return true;
      } else {
        _errorMessage = response?['message'] ?? 'Unknown update error';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error updating coupon: ${e.toString()}';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // Toggle active
  Future<bool> toggleCouponActiveStatus(String couponId) async {
    try {
      final coupon = _coupons.firstWhere((c) => c.id == couponId);
      final updated = coupon.copyWith(active: !coupon.active);
      return await updateCoupon(updated);
    } catch (e) {
      _errorMessage = 'Error toggling active: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Toggle featured
  Future<bool> toggleCouponFeaturedStatus(String couponId) async {
    try {
      final coupon = _coupons.firstWhere((c) => c.id == couponId);
      final updated = coupon.copyWith(featuredForHome: !coupon.featuredForHome);
      return await updateCoupon(updated);
    } catch (e) {
      _errorMessage = 'Error toggling featured: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}
