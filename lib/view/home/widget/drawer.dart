import 'package:coupon_admin_panel/model/page_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/admin_view_model.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final adminViewModel = Provider.of<AdminViewModel>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildExpansionTile(
            context,
            icon: Icons.supervised_user_circle,
            title: "Coupons",
            options: [
              _buildSubListTile(
                  context, "Add Coupon", AdminPage.addCoupon, adminViewModel),
              _buildSubListTile(context, "Update Coupon",
                  AdminPage.updateCoupon, adminViewModel),
            ],
          ),
          _buildExpansionTile(
            context,
            icon: Icons.store,
            title: "Stores",
            options: [
              _buildSubListTile(
                  context, "Add Store", AdminPage.addStore, adminViewModel),
              _buildSubListTile(
                  context, "All Store", AdminPage.allStore, adminViewModel),
              _buildSubListTile(context, "Update Store", AdminPage.updateStore,
                  adminViewModel),
            ],
          ),
          _buildExpansionTile(
            context,
            icon: Icons.category,
            title: "Categories",
            options: [
              _buildSubListTile(context, "All Categories", AdminPage.category,
                  adminViewModel),
              _buildSubListTile(context, "Add Category", AdminPage.addCategory,
                  adminViewModel),
              _buildSubListTile(context, "Update Category",
                  AdminPage.updateCategory, adminViewModel),
            ],
          ),
          _buildExpansionTile(
            context,
            icon: Icons.person,
            title: "Users",
            options: [
              _buildSubListTile(
                  context, "Manage Users", AdminPage.users, adminViewModel),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> options,
  }) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title),
      children: options,
    );
  }

  Widget _buildSubListTile(
    BuildContext context,
    String title,
    AdminPage page,
    AdminViewModel adminViewModel,
  ) {
    return ListTile(
      title: Text(title),
      onTap: () {
        adminViewModel.selectPage(page);
      },
    );
  }
}
