import 'package:flutter/material.dart';
import 'package:coupon_admin_panel/view_model/coupon_view_model/coupon_view_model.dart';
import 'package:coupon_admin_panel/utils/utils.dart';

class CouponFormViewModel with ChangeNotifier {
  // Form controllers
  final TextEditingController codeController = TextEditingController();
  final TextEditingController offerDetailsController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Form state
  String? _selectedStoreId;
  bool _isCodeSelected = false;
  bool _isActiveSelected = true;
  bool _isFeaturedForHome = false;

  // Getters
  String? get selectedStoreId => _selectedStoreId;
  bool get isCodeSelected => _isCodeSelected;
  bool get isActiveSelected => _isActiveSelected;
  bool get isFeaturedForHome => _isFeaturedForHome;

  // Setters with notification
  void setSelectedStoreId(String? value) {
    _selectedStoreId = value;
    notifyListeners();
  }

  void setIsCodeSelected(bool value) {
    _isCodeSelected = value;
    if (value) {
      _isActiveSelected = false;
    }
    notifyListeners();
  }

  void setIsActiveSelected(bool value) {
    _isActiveSelected = value;
    if (value) {
      _isCodeSelected = false;
    }
    notifyListeners();
  }

  void setIsFeaturedForHome(bool value) {
    _isFeaturedForHome = value;
    notifyListeners();
  }

  // Form submission
  Future<void> submitForm(
      BuildContext context, CouponViewModel couponViewModel) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final couponData = {
      "offerDetails": offerDetailsController.text,
      "code": isCodeSelected ? codeController.text : '',
      "store": selectedStoreId,
      "active": isActiveSelected,
      "featuredForHome": isFeaturedForHome,
    };

    try {
      final success = await couponViewModel.createCoupon(couponData);
      if (success) {
        Utils.toastMessage('Coupon created successfully!');
        clearForm();
      } else {
        Utils.toastMessage('Failed to create coupon. Please try again.');
      }
    } catch (e) {
      Utils.toastMessage('Error creating coupon: ${e.toString()}');
    }
  }

  // Clear form fields and reset state
  void clearForm() {
    codeController.clear();
    offerDetailsController.clear();
    _selectedStoreId = null;
    _isCodeSelected = false;
    _isActiveSelected = true;
    _isFeaturedForHome = false;
    notifyListeners();
  }

  @override
  void dispose() {
    codeController.dispose();
    offerDetailsController.dispose();
    super.dispose();
  }
}
