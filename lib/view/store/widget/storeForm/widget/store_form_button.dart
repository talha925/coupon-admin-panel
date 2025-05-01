import 'package:coupon_admin_panel/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';
import 'package:coupon_admin_panel/view_model/services/image_picker_view_model.dart';

import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:coupon_admin_panel/utils/utils.dart';

class StoreFormButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController shortDescriptionController;
  final TextEditingController longDescriptionController;
  final TextEditingController trackingUrlController;
  final TextEditingController metaTitleController;
  final TextEditingController metaDescriptionController;
  final TextEditingController metaKeywordsController;

  final String? selectedCategory;
  final bool topStore;
  final bool editorsChoice;
  final String language;

  // This store parameter may cause the issue when not properly updated
  final Data? store;

  final ValueNotifier<bool> isSubmitting = ValueNotifier(false);

  StoreFormButton({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.shortDescriptionController,
    required this.longDescriptionController,
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
        // Use selectedStore from ViewModel instead of passed store property
        final selectedStore = storeViewModel.selectedStore;
        final isEditMode = selectedStore != null;

        return ValueListenableBuilder<bool>(
          valueListenable: isSubmitting,
          builder: (context, submitting, child) {
            return submitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      await _submitStore(context, storeViewModel);
                    },
                    child: Text(isEditMode ? 'Update Store' : 'Create Store'),
                  );
          },
        );
      },
    );
  }

  Future<void> _submitStore(
      BuildContext context, StoreViewModel storeViewModel) async {
    if (!formKey.currentState!.validate()) {
      Utils.toastMessage('Please fix validation errors in the form.');
      return;
    }

    isSubmitting.value = true;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final imagePickerVM =
        Provider.of<ImagePickerViewModel>(context, listen: false);

    // Get the actual selected store from ViewModel
    final selectedStore = storeViewModel.selectedStore;
    String? uploadedImageUrl = selectedStore?.image.url;

    try {
      final selectedHeading = storeViewModel.selectedHeading;

      // Upload image in creation case
      if (selectedStore == null && imagePickerVM.selectedImageBytes != null) {
        try {
          uploadedImageUrl = await imagePickerVM.uploadImageToS3();
        } catch (e) {
          _showError(scaffoldMessenger, 'Image upload failed: $e');
          isSubmitting.value = false;
          return;
        }
      }

      // Ensure image is present on creation
      if (selectedStore == null &&
          (uploadedImageUrl == null || uploadedImageUrl.isEmpty)) {
        _showError(scaffoldMessenger, 'Store image is required.');
        isSubmitting.value = false;
        return;
      }

      final storeDataObj = Data(
        id: selectedStore?.id ?? '',
        name: nameController.text.trim(),
        trackingUrl: trackingUrlController.text.trim(),
        shortDescription: shortDescriptionController.text.trim(),
        longDescription: longDescriptionController.text.trim(),
        image: StoreImage(
          url: uploadedImageUrl ?? '',
          alt: imagePickerVM.selectedImageAlt?.trim() ??
              '${nameController.text.trim()} Logo',
        ),
        categories: selectedCategory != null
            ? [CategoryData(id: selectedCategory!, name: '')]
            : [],
        seo: Seo(
          metaTitle: metaTitleController.text.trim(),
          metaDescription: metaDescriptionController.text.trim(),
          metaKeywords: metaKeywordsController.text.trim(),
        ),
        language: language,
        isTopStore: storeViewModel.isTopStore,
        isEditorsChoice: storeViewModel.isEditorsChoice,
        heading: selectedHeading!,
      );

      scaffoldMessenger
          .showSnackBar(const SnackBar(content: Text('Saving store...')));

      final success = selectedStore != null
          ? await storeViewModel.updateStore(storeDataObj, context)
          : await storeViewModel.createStore(storeDataObj, context);

      scaffoldMessenger.hideCurrentSnackBar();

      if (success) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(selectedStore != null
                ? 'Store updated successfully!'
                : 'Store created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        if (selectedStore == null) {
          _clearFormFields();
          imagePickerVM.clearImage();
        }
      }
    } catch (e) {
      scaffoldMessenger.hideCurrentSnackBar();
      debugPrint('Showing error to user: $e'); // Print to console

      _showError(scaffoldMessenger, 'Unexpected error: ${e.toString()}');
    } finally {
      isSubmitting.value = false;
    }
  }

  void _showError(ScaffoldMessengerState messenger, String message) {
    isSubmitting.value = false;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _clearFormFields() {
    nameController.clear();
    trackingUrlController.clear();
    metaTitleController.clear();
    metaDescriptionController.clear();
    metaKeywordsController.clear();
    shortDescriptionController.clear();
    longDescriptionController.clear();
  }
}
