// lib/view/home/main_page.dart

import 'package:coupon_admin_panel/model/page_model.dart';
import 'package:coupon_admin_panel/view/coupon/coupon_page.dart';
import 'package:coupon_admin_panel/view/home/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/admin_view_model.dart';

import '../category/category_screen.dart';
import '../store/store_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final adminViewModel = Provider.of<AdminViewModel>(context);

    return Scaffold(
      body: Row(
        children: [
          const DrawerWidget(), // Fixed Drawer on the left
          Expanded(
              child: _buildPageContent(
                  adminViewModel.currentPage) // Main content on the right
              ),
        ],
      ),
    );
  }

  Widget _buildPageContent(AdminPage currentPage) {
    switch (currentPage) {
      case AdminPage.coupons:
        return const CreateCouponPage();
      case AdminPage.stores:
        return const CreateStorePage();
      case AdminPage.users:
        return const UsersPage();
      case AdminPage.category:
        return const CategoryScreen();
      default:
        return const Center(child: Text('Select a page'));
    }
  }
}

// class CouponPage extends StatelessWidget {
//   const CouponPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Coupon Page'));
//   }
// }

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Users Page'));
  }
}
