import 'package:coupon_admin_panel/model/page_model.dart';
import 'package:coupon_admin_panel/view/coupon/coupon_page.dart';
import 'package:coupon_admin_panel/view/home/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/admin_view_model.dart';

import '../category/category_screen.dart';
import '../store/store_page.dart';
import '../store/widget/store_list_widget/store_list_get_widget.dart';

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
      case AdminPage.addCoupon:
        return const CreateCouponPage();
      case AdminPage.updateCoupon:
        return const UpdateCouponPage();
      case AdminPage.addStore:
        return const CreateStorePage();
      case AdminPage.allStore:
        return const StoreListPage();
      case AdminPage.updateStore:
        return const UpdateStorePage();
      case AdminPage.addCategory:
        return const AddCategoryPage();
      case AdminPage.updateCategory:
        return const UpdateCategoryPage();
      default:
        return const Center(child: Text('Select a page'));
    }
  }
}

class updateCategory extends StatelessWidget {
  const updateCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Coupon Page'));
  }
}

class AddCategoryPage extends StatelessWidget {
  const AddCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Users Page'));
  }
}

class AddStorePage extends StatelessWidget {
  const AddStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Coupon Page'));
  }
}

class UpdateCategoryPage extends StatelessWidget {
  const UpdateCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Users Page'));
  }
}

class AddCouponPage extends StatelessWidget {
  const AddCouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Coupon")),
      body: const Center(
        child: Text('This is the Add Coupon Page'),
      ),
    );
  }
}

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Users Page'));
  }
}

class UpdateStorePage extends StatelessWidget {
  const UpdateStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Users Page'));
  }
}

class UpdateCouponPage extends StatelessWidget {
  const UpdateCouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Coupon")),
      body: const Center(
        child: Text('This is the Update Coupon Page'),
      ),
    );
  }
}
