import 'package:coupon_admin_panel/model/page_model.dart';
import 'package:coupon_admin_panel/view/coupon/coupon_page.dart';
import 'package:coupon_admin_panel/view/home/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/admin_view_model.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';
import 'package:coupon_admin_panel/view/store/widget/storeForm/store_form.dart';
import 'package:coupon_admin_panel/view/coupon/widget/coupon_list_item/coupon_list_page.dart';

import '../category/category_screen.dart';
import '../store/store_page.dart';
import '../store/widget/store_list_widget/store_list_get_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const DrawerWidget(), // Fixed Drawer on the left
          Expanded(
            child: Selector<AdminViewModel, AdminPage>(
              selector: (_, viewModel) => viewModel.currentPage,
              builder: (context, currentPage, child) {
                return _buildPageContent(currentPage);
              },
            ),
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
        return const CouponListByStorePage(); // Ensure this is correctly added
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
    return const Center(child: Text('Category Update Page'));
  }
}

class AddCategoryPage extends StatelessWidget {
  const AddCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Add Category Page'));
  }
}

class AddStorePage extends StatelessWidget {
  const AddStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Add Store Page'));
  }
}

class UpdateCategoryPage extends StatelessWidget {
  const UpdateCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Update Category Page'));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Store'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to store list
            Provider.of<AdminViewModel>(context, listen: false)
                .selectPage(AdminPage.allStore);
          },
        ),
      ),
      body: Consumer<StoreViewModel>(
        builder: (context, storeViewModel, _) {
          final selectedStore = storeViewModel.selectedStore;

          if (selectedStore == null) {
            // If no store is selected, show an error message and return to list
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No store selected for editing'),
                  backgroundColor: Colors.red,
                ),
              );
              Provider.of<AdminViewModel>(context, listen: false)
                  .selectPage(AdminPage.allStore);
            });

            return const Center(
              child: Text('No store selected'),
            );
          }

          // Show loading indicator if submitting
          if (storeViewModel.isSubmitting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show error message if there is one
          if (storeViewModel.errorMessage != null &&
              storeViewModel.errorMessage!.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    storeViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<AdminViewModel>(context, listen: false)
                          .selectPage(AdminPage.allStore);
                    },
                    child: const Text('Back to Stores'),
                  ),
                ],
              ),
            );
          }

          // Show the form with the selected store data
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Use the existing StoreFormWidget with the selected store
                StoreFormWidget(store: selectedStore),
              ],
            ),
          );
        },
      ),
    );
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
