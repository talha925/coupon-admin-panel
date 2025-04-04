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

  // Update selected store for filtering
  void updateSelectedStore(String? newStoreId) {
    _selectedStoreId = newStoreId;
    _filterCoupons();
    notifyListeners();
  }

  // Filter coupons based on selected store
  void _filterCoupons() {
    if (_selectedStoreId == null || _selectedStoreId!.isEmpty) {
      _filteredCoupons = List.from(_coupons);
    } else {
      _filteredCoupons = _coupons
          .where((coupon) => coupon.storeId == _selectedStoreId)
          .toList();
    }
  }

  // Search coupons by code or offer details
  void searchCoupons(String query) {
    if (query.isEmpty) {
      _filterCoupons();
    } else {
      final lowercaseQuery = query.toLowerCase();
      _filteredCoupons = _coupons.where((coupon) {
        return coupon.code.toLowerCase().contains(lowercaseQuery) ||
            coupon.offerDetails.toLowerCase().contains(lowercaseQuery);
      }).toList();
    }
    notifyListeners();
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
    _isSubmitting = true;
    notifyListeners();

    try {
      await _couponRepository.createCoupon(couponData);
      await getCoupons();
      return true;
    } catch (e) {
      _errorMessage = 'Error creating coupon: ${e.toString()}';
      return false;
    } finally {
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
