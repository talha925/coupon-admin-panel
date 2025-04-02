import 'dart:convert';

import 'package:coupon_admin_panel/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';
import 'package:coupon_admin_panel/view_model/services/image_picker_view_model_web.dart';
import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:coupon_admin_panel/utils/utils.dart';

class StoreFormButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController shortDescriptionController;
  final TextEditingController longDescriptionController;
  final TextEditingController directUrlController;
  final TextEditingController trackingUrlController;
  final TextEditingController metaTitleController;
  final TextEditingController metaDescriptionController;
  final TextEditingController metaKeywordsController;

  final String? selectedCategory;
  final bool topStore;
  final bool editorsChoice;
  final String language;
  final Data? store; // ✅ Store for editing mode

  // ✅ Using ValueNotifier to track submitting state
  final ValueNotifier<bool> isSubmitting = ValueNotifier(false);

  StoreFormButton({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.shortDescriptionController,
    required this.longDescriptionController,
    required this.directUrlController,
    required this.trackingUrlController,
    required this.metaTitleController,
    required this.metaDescriptionController,
    required this.metaKeywordsController,
    required this.selectedCategory,
    required this.topStore,
    required this.editorsChoice,
    required this.language,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, storeViewModel, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: isSubmitting,
          builder: (context, submitting, child) {
            return submitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      await _submitStore(context, storeViewModel);
                    },
                    child:
                        Text(store == null ? 'Create Store' : 'Update Store'),
                  );
          },
        );
      },
    );
  }

  Future<void> _submitStore(
      BuildContext context, StoreViewModel storeViewModel) async {
    if (!formKey.currentState!.validate()) {
      Utils.toastMessage('Please fill in all required fields.');
      return;
    }

    // Show loading state
    isSubmitting.value = true;
    final ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);

    final imagePickerViewModel =
        Provider.of<ImagePickerViewModel>(context, listen: false);

    String? uploadedImageUrl = store?.image.url; // Keep existing image

    try {
      // Handle image upload if needed
      if (imagePickerViewModel.selectedImageBytes != null) {
        try {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Uploading image...'),
              duration: Duration(seconds: 2),
            ),
          );

          uploadedImageUrl = await imagePickerViewModel.uploadImageToS3();

          if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) {
            throw Exception('Failed to upload image');
          }
        } catch (e) {
          scaffoldMessenger.hideCurrentSnackBar();
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Image upload failed: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          isSubmitting.value = false;
          return;
        }
      }

      // Get selected heading from StoreViewModel
      String selectedHeading =
          storeViewModel.selectedHeading ?? 'Coupons & Promo Codes';

      // Get latest toggle values from UI before sending
      final bool finalTopStore = storeViewModel.isTopStore;
      final bool finalEditorsChoice = storeViewModel.isEditorsChoice;

      // Create store data object
      final storeData = Data(
        id: store?.id ?? '',
        name: nameController.text.trim(),
        directUrl: directUrlController.text.trim(),
        trackingUrl: trackingUrlController.text.trim(),
        image: StoreImage(
          url: uploadedImageUrl ?? '',
          alt: imagePickerViewModel.selectedImageAlt?.trim() ??
              'Default Alt Text',
        ),
        seo: Seo(
          metaTitle: metaTitleController.text.trim(),
          metaDescription: metaDescriptionController.text.trim(),
          metaKeywords: metaKeywordsController.text.trim(),
        ),
        categories: selectedCategory != null
            ? [CategoryData(id: selectedCategory!, name: '')]
            : [],
        language: language,
        createdAt: store?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        v: 0,
        shortDescription: shortDescriptionController.text.trim(),
        longDescription: longDescriptionController.text.trim(),
        slug: nameController.text.trim().toLowerCase().replaceAll(' ', '-'),
        isTopStore: finalTopStore,
        isEditorsChoice: finalEditorsChoice,
        heading: selectedHeading,
      );

      // Submit data to API
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Saving store...'),
          duration: Duration(seconds: 2),
        ),
      );

      bool success = false;
      if (store != null) {
        success = await storeViewModel.updateStore(storeData);
      } else {
        success = await storeViewModel.createStore(storeData);
      }

      scaffoldMessenger.hideCurrentSnackBar();

      if (success) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(store != null
                ? 'Store updated successfully!'
                : 'Store created successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Clear form on success
        _clearFormFields();
        imagePickerViewModel.clearImage();
      } else {
        // Show error message from view model
        final errorMessage =
            storeViewModel.errorMessage ?? 'Failed to save store data';
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  /// ✅ Clears all form input fields after successful submission
  void _clearFormFields() {
    nameController.clear();
    directUrlController.clear();
    trackingUrlController.clear();
    metaTitleController.clear();
    metaDescriptionController.clear();
    metaKeywordsController.clear();
    shortDescriptionController.clear();
    longDescriptionController.clear();
  }

  /// ✅ Separate validation logic
  bool _validateFields(String? uploadedImageUrl, String? selectedHeading) {
    if (nameController.text.trim().isEmpty) return false;
    if (directUrlController.text.trim().isEmpty ||
        !Uri.parse(directUrlController.text.trim()).isAbsolute) return false;
    if (trackingUrlController.text.trim().isEmpty ||
        !Uri.parse(trackingUrlController.text.trim()).isAbsolute) return false;
    if (shortDescriptionController.text.trim().isEmpty) return false;
    if (longDescriptionController.text.trim().isEmpty) return false;
    if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) return false;
    if (selectedHeading == null ||
        ![
          'Promo Codes & Coupon',
          'Coupons & Promo Codes',
          'Voucher & Discount Codes'
        ].contains(selectedHeading)) {
      return false;
    }
    return true;
  }
}
