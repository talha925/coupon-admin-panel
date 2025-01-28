import 'package:flutter/foundation.dart';
import 'package:coupon_admin_panel/repository/coupon_repository.dart';
import 'package:coupon_admin_panel/model/coupon_model.dart';

class CouponViewModel with ChangeNotifier {
  final CouponRepository _couponRepository = CouponRepository();

  // Separate loading states
  bool _isFetching = false;
  bool _isSubmitting = false;

  // Getters for loading states
  bool get isFetching => _isFetching;
  bool get isSubmitting => _isSubmitting;

  List<Datum> _coupons = [];
  List<Datum> get coupons => _coupons;

  String? _selectedStoreId;

  String? get selectedStoreId => _selectedStoreId;

  void updateSelectedStore(String? newStoreId) {
    _selectedStoreId = newStoreId;
    notifyListeners();
  }

  // Fetch coupons from the repository
  Future<void> getCoupons() async {
    _isFetching = true;
    notifyListeners();

    try {
      final List<Datum> fetchedCoupons = await _couponRepository.fetchCoupons();

      // Clear the existing list and then add the new fetched coupons
      _coupons.clear();

      // Add the new fetched coupons
      _coupons.addAll(fetchedCoupons);

      // Reverse the list to have the most recent coupons at the top
      _coupons = _coupons.reversed.toList(); // Reverse the list here
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching coupons: $e');
      }
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  Future<void> createCoupon(Datum coupon) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await _couponRepository.createCoupon(coupon.toJson());
      // Directly add the new coupon to the list
      _coupons.insert(0, coupon); // Insert at the beginning
    } catch (e) {
      if (kDebugMode) {
        print('Error creating coupon: $e');
      }
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // Delete coupon
  Future<void> deleteCoupon(String couponId) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await _couponRepository.deleteCoupon(couponId);
      await getCoupons(); // Refresh the list after deleting a coupon
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting coupon: $e');
      }
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // Update coupon
  Future<void> updateCoupon(Datum coupon) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await _couponRepository.updateCoupon(coupon.toJson());
      await getCoupons(); // Refresh the list after updating a coupon
    } catch (e) {
      if (kDebugMode) {
        print('Error updating coupon: $e');
      }
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
