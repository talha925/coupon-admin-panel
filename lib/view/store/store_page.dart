import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/res/components/components.dart';
import 'package:coupon_admin_panel/res/theme/theme.dart';
import 'package:coupon_admin_panel/view/store/widget/storeForm/store_form.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';
import 'package:coupon_admin_panel/view_model/admin_view_model.dart';
import 'package:coupon_admin_panel/model/page_model.dart';

class CreateStorePage extends StatefulWidget {
  const CreateStorePage({super.key});

  @override
  CreateStorePageState createState() => CreateStorePageState();
}

class CreateStorePageState extends State<CreateStorePage> {
  @override
  void initState() {
    super.initState();
    // Reset the selected store when this page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<StoreViewModel>(context, listen: false)
            .resetSelectedStore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Consumer<StoreViewModel>(
        builder: (context, storeViewModel, _) {
          return Column(
            children: [
              // Page header with title and description
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.paddingL,
                  AppDimensions.paddingL,
                  AppDimensions.paddingL,
                  AppDimensions.paddingM,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Store',
                          style: AppTypography.headingMedium.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingXS),
                        Text(
                          'Add a new store to the system with all required details',
                          style: AppTypography.bodyMedium.copyWith(
                            color: colorScheme.onSurface.withAlpha(179),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    EnhancedButton(
                      label: 'Back to Stores',
                      prefixIcon: Icons.arrow_back,
                      variant: ButtonVariant.outline,
                      onPressed: () {
                        // Navigate back to store list
                        Provider.of<AdminViewModel>(context, listen: false)
                            .selectPage(AdminPage.allStore);
                      },
                    ),
                  ],
                ),
              ),

              // Error message display with improved UI
              if (storeViewModel.errorMessage != null &&
                  storeViewModel.errorMessage!.isNotEmpty)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingL,
                    vertical: AppDimensions.paddingS,
                  ),
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withAlpha(26),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    border: Border.all(
                      color: colorScheme.error.withAlpha(77),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: colorScheme.error.withAlpha(179),
                        size: AppDimensions.iconM,
                      ),
                      const SizedBox(width: AppDimensions.paddingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Error',
                              style: AppTypography.titleSmall.copyWith(
                                color: colorScheme.error.withAlpha(179),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingXS),
                            Text(
                              storeViewModel.errorMessage!,
                              style: AppTypography.bodyMedium.copyWith(
                                color: colorScheme.error.withAlpha(230),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: colorScheme.error.withAlpha(179),
                          size: AppDimensions.iconS,
                        ),
                        onPressed: () {
                          // Clear error message
                          storeViewModel.clearError();
                        },
                      ),
                    ],
                  ),
                ),

              // Main content
              Expanded(
                child: Stack(
                  children: [
                    // Form with scrolling
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(AppDimensions.paddingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Store form wrapped in EnhancedCard
                          EnhancedCard(
                            padding:
                                const EdgeInsets.all(AppDimensions.paddingL),
                            elevation: AppDimensions.elevationS,
                            child: StoreFormWidget(),
                          ),
                          const SizedBox(height: AppDimensions.paddingL),
                        ],
                      ),
                    ),

                    // Loading overlay with improved visual feedback
                    if (storeViewModel.isSubmitting)
                      Container(
                        color: colorScheme.scrim.withAlpha(77),
                        child: Center(
                          child: EnhancedCard(
                            padding:
                                const EdgeInsets.all(AppDimensions.paddingL),
                            elevation: AppDimensions.elevationL,
                            width: 120,
                            height: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: colorScheme.primary,
                                  strokeWidth: 3,
                                ),
                                const SizedBox(height: AppDimensions.paddingM),
                                Text(
                                  'Saving...',
                                  style: AppTypography.labelLarge.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
