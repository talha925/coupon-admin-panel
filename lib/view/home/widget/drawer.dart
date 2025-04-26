import 'package:coupon_admin_panel/model/page_model.dart';
import 'package:coupon_admin_panel/res/theme/app_dimensions.dart';
import 'package:coupon_admin_panel/res/theme/app_typography.dart';
import 'package:coupon_admin_panel/view/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/admin_view_model.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final adminViewModel = Provider.of<AdminViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: AppDimensions.drawerWidth,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.black12,
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildNavigationSection(
                    context,
                    adminViewModel,
                    icon: Icons.receipt_outlined,
                    title: "Coupons",
                    options: [
                      _buildNavItem(
                        context,
                        "Add Coupon",
                        AdminPage.addCoupon,
                        adminViewModel,
                        icon: Icons.add_circle_outline,
                      ),
                      _buildNavItem(
                        context,
                        "Update Coupon",
                        AdminPage.updateCoupon,
                        adminViewModel,
                        icon: Icons.edit_outlined,
                      ),
                    ],
                  ),
                  _buildNavigationSection(
                    context,
                    adminViewModel,
                    icon: Icons.store_outlined,
                    title: "Stores",
                    options: [
                      _buildNavItem(
                        context,
                        "Add Store",
                        AdminPage.addStore,
                        adminViewModel,
                        icon: Icons.add_business_outlined,
                      ),
                      _buildNavItem(
                        context,
                        "All Stores",
                        AdminPage.allStore,
                        adminViewModel,
                        icon: Icons.view_list_outlined,
                      ),
                      _buildNavItem(
                        context,
                        "Update Store",
                        AdminPage.updateStore,
                        adminViewModel,
                        icon: Icons.edit_outlined,
                      ),
                    ],
                  ),
                  _buildNavigationSection(
                    context,
                    adminViewModel,
                    icon: Icons.category_outlined,
                    title: "Categories",
                    options: [
                      _buildNavItem(
                        context,
                        "All Categories",
                        AdminPage.category,
                        adminViewModel,
                        icon: Icons.view_list_outlined,
                      ),
                      _buildNavItem(
                        context,
                        "Add Category",
                        AdminPage.addCategory,
                        adminViewModel,
                        icon: Icons.add_circle_outline,
                      ),
                      _buildNavItem(
                        context,
                        "Update Category",
                        AdminPage.updateCategory,
                        adminViewModel,
                        icon: Icons.edit_outlined,
                      ),
                    ],
                  ),
                  _buildNavigationSection(
                    context,
                    adminViewModel,
                    icon: Icons.person_outline,
                    title: "Users",
                    options: [
                      _buildNavItem(
                        context,
                        "Manage Users",
                        AdminPage.users,
                        adminViewModel,
                        icon: Icons.people_outline,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Add theme toggle at the bottom
          const ThemeToggle(),

          // Add a profile section at the bottom
          _buildProfileSection(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingM,
        AppDimensions.paddingL + 16, // Add extra space for status bar
        AppDimensions.paddingM,
        AppDimensions.paddingM,
      ),
      color: colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    colorScheme.onPrimary.withAlpha(51), // 0.2 opacity = 51/255
                child: Icon(
                  Icons.admin_panel_settings_outlined,
                  color: colorScheme.onPrimary
                      .withAlpha(204), // 0.8 opacity = 204/255
                  size: 28,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coupon Admin',
                    style: AppTypography.titleMedium.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Management Panel',
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onPrimary
                          .withAlpha(153), // 0.6 opacity = 153/255
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationSection(
    BuildContext context,
    AdminViewModel adminViewModel, {
    required IconData icon,
    required String title,
    required List<Widget> options,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ExpansionTile(
      leading: Icon(
        icon,
        color: colorScheme.onSurface.withAlpha(179), // 0.7 opacity = 179/255
        size: AppDimensions.iconM,
      ),
      title: Text(
        title,
        style: AppTypography.titleSmall.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      childrenPadding: const EdgeInsets.only(left: AppDimensions.paddingL),
      iconColor: colorScheme.primary,
      collapsedIconColor:
          colorScheme.onSurface.withAlpha(128), // 0.5 opacity = 128/255
      children: options,
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String title,
    AdminPage page,
    AdminViewModel adminViewModel, {
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = adminViewModel.currentPage == page;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
      ),
      leading: Icon(
        icon,
        size: AppDimensions.iconS,
        color: isSelected
            ? colorScheme.primary.withAlpha(204) // 0.8 opacity = 204/255
            : colorScheme.onSurface.withAlpha(153), // 0.6 opacity = 153/255
      ),
      title: Text(
        title,
        style: isSelected
            ? AppTypography.bodyMedium.copyWith(
                color:
                    colorScheme.primary.withAlpha(204), // 0.8 opacity = 204/255
                fontWeight: FontWeight.w600,
              )
            : AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurface
                    .withAlpha(204), // 0.8 opacity = 204/255
              ),
      ),
      onTap: () {
        adminViewModel.selectPage(page);
      },
      selected: isSelected,
      selectedTileColor:
          colorScheme.primary.withAlpha(20), // 0.08 opacity = 20/255
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest
            .withAlpha(77), // 0.3 opacity = 77/255
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withAlpha(51), // 0.2 opacity = 51/255
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor:
                colorScheme.primary.withAlpha(51), // 0.2 opacity = 51/255
            child: Icon(
              Icons.person_outline,
              size: 18,
              color:
                  colorScheme.primary.withAlpha(204), // 0.8 opacity = 204/255
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin User',
                  style: AppTypography.labelLarge.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'admin@example.com',
                  style: AppTypography.bodySmall.copyWith(
                    color: colorScheme.onSurface
                        .withAlpha(153), // 0.6 opacity = 153/255
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.logout_outlined,
              size: AppDimensions.iconS,
              color: colorScheme.error.withAlpha(204), // 0.8 opacity = 204/255
            ),
            tooltip: 'Logout',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
