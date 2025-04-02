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

  // Search coupons by name or description
  void searchCoupons(String query) {
    if (query.isEmpty) {
      _filterCoupons(); // Reset to current filter
    } else {
      final lowercaseQuery = query.toLowerCase();
      _filteredCoupons = _coupons.where((coupon) {
        final lowerCode = coupon.code.toLowerCase();
        final lowerOfferDetails = coupon.offerDetails.toLowerCase();

        return lowerCode.contains(lowercaseQuery) ||
            lowerOfferDetails.contains(lowercaseQuery);
      }).toList();
    }
    notifyListeners();
  }

  // Fetch coupons from the repository
  Future<void> getCoupons() async {
    _isFetching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<CouponData> fetchedCoupons =
          await _couponRepository.fetchCoupons();

      _coupons = fetchedCoupons;

      // Sort coupons with featured ones first
      _coupons.sort((a, b) {
        if (a.featuredForHome != b.featuredForHome) {
          return a.featuredForHome ? -1 : 1;
        }
        return 0;
      });

      _filterCoupons();
    } catch (e) {
      _errorMessage = 'Error fetching coupons: ${e.toString()}';
      if (kDebugMode) {
        print(_errorMessage);
      }
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  // Create coupon
  Future<bool> createCoupon(Map<String, dynamic> couponData) async {
    try {
      _isSubmitting = true;
      notifyListeners();

      await _couponRepository.createCoupon(couponData);
      await getCoupons(); // Refresh the list after creating

      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      if (kDebugMode) {
        print("Error creating coupon: $e");
      }
      return false;
    }
  }

  // Delete coupon
  Future<bool> deleteCoupon(String couponId) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _couponRepository.deleteCoupon(couponId);
      await getCoupons(); // Refresh the list after deleting
      return true;
    } catch (e) {
      _errorMessage = 'Error deleting coupon: ${e.toString()}';
      if (kDebugMode) {
        print(_errorMessage);
      }
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
        await getCoupons(); // Refresh coupons after successful update
        return true;
      } else {
        _errorMessage = response != null && response['message'] != null
            ? 'Failed to update coupon: ${response['message']}'
            : 'Failed to update coupon: Unknown error';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error updating coupon: ${e.toString()}';
      if (kDebugMode) {
        print(_errorMessage);
      }
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // Toggle coupon activation status
  Future<bool> toggleCouponActiveStatus(String couponId) async {
    try {
      final coupon = _coupons.firstWhere((c) => c.id == couponId);
      final updatedCoupon = CouponData(
        id: coupon.id,
        code: coupon.code,
        offerDetails: coupon.offerDetails,
        active: !coupon.active,
        isValid: coupon.isValid,
        featuredForHome: coupon.featuredForHome,
        hits: coupon.hits,
        lastAccessed: coupon.lastAccessed,
        storeId: coupon.storeId,
      );
      final success = await updateCoupon(updatedCoupon);
      if (success) {
        final index = _coupons.indexWhere((c) => c.id == couponId);
        if (index != -1) {
          _coupons[index] = updatedCoupon;
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _errorMessage = 'Error toggling coupon status: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Toggle featured for home status
  Future<bool> toggleCouponFeaturedStatus(String couponId) async {
    try {
      final coupon = _coupons.firstWhere((c) => c.id == couponId);
      final updatedCoupon = CouponData(
        id: coupon.id,
        code: coupon.code,
        offerDetails: coupon.offerDetails,
        active: coupon.active,
        isValid: coupon.isValid,
        featuredForHome: !coupon.featuredForHome,
        hits: coupon.hits,
        lastAccessed: coupon.lastAccessed,
        storeId: coupon.storeId,
      );
      final success = await updateCoupon(updatedCoupon);
      if (success) {
        final index = _coupons.indexWhere((c) => c.id == couponId);
        if (index != -1) {
          _coupons[index] = updatedCoupon;
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _errorMessage = 'Error toggling featured status: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}
