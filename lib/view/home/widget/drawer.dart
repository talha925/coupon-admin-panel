// lib/view/home/widget/drawer_widget.dart

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
          _buildListTile(
            context,
            icon: Icons.supervised_user_circle,
            page: AdminPage.coupons,
            selectedPage: adminViewModel.currentPage,
            adminViewModel: adminViewModel,
          ),
          _buildListTile(
            context,
            icon: Icons.store,
            page: AdminPage.stores,
            selectedPage: adminViewModel.currentPage,
            adminViewModel: adminViewModel,
          ),
          _buildListTile(
            context,
            icon: Icons.person,
            page: AdminPage.users,
            selectedPage: adminViewModel.currentPage,
            adminViewModel: adminViewModel,
          ),
          _buildListTile(
            context,
            icon: Icons.person,
            page: AdminPage.category,
            selectedPage: adminViewModel.currentPage,
            adminViewModel: adminViewModel,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required AdminPage page,
    required AdminPage selectedPage,
    required AdminViewModel adminViewModel,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(page.name),
      selected: page == selectedPage,
      onTap: () => adminViewModel.selectPage(page),
    );
  }
}
