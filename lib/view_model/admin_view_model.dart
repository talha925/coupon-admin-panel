// lib/view_model/admin_view_model.dart

import 'package:flutter/material.dart';
import 'package:coupon_admin_panel/model/page_model.dart';

class AdminViewModel with ChangeNotifier {
  AdminPage _currentPage = AdminPage.stores;

  AdminPage get currentPage => _currentPage;

  void selectPage(AdminPage page) {
    _currentPage = page;
    notifyListeners();
  }
}
