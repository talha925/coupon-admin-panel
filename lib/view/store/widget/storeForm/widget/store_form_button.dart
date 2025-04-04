import 'dart:convert';

import 'package:coupon_admin_panel/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';
import 'package:coupon_admin_panel/view_model/services/image_picker_view_model_web.dart';
import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:coupon_admin_panel/utils/utils.dart';
import 'package:coupon_admin_panel/utils/form_util.dart';

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
    // First validate the form using the built-in validators
    if (!formKey.currentState!.validate()) {
      Utils.toastMessage('Please fix validation errors in the form.');
      return;
    }

    isSubmitting.value = true;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final imagePickerVM =
        Provider.of<ImagePickerViewModel>(context, listen: false);
    String? uploadedImageUrl = store?.image.url;

    try {
      // Log validation info to help debug URL validation issues
      Map<String, dynamic> storeData = {
        'trackingUrl': trackingUrlController.text.trim(),
        'heading': storeViewModel.selectedHeading,
      };
      FormUtils.logValidationInfo(storeData);

      // Upload image if one is selected
      if (imagePickerVM.selectedImageBytes != null) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Uploading image...')),
        );

        uploadedImageUrl = await imagePickerVM.uploadImageToS3();
        if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) {
          throw Exception('Image upload failed.');
        }

        scaffoldMessenger.hideCurrentSnackBar();
      }

      final selectedHeading = storeViewModel.selectedHeading;

      // Additional validation using FormUtils
      String? trackingUrlError =
          FormUtils.validateWebsite(trackingUrlController.text.trim());
      if (trackingUrlError != null) {
        _showError(scaffoldMessenger, 'Tracking URL Error: $trackingUrlError');
        return;
      }

      String? headingError = FormUtils.validateHeading(selectedHeading);
      if (headingError != null) {
        _showError(scaffoldMessenger, headingError);
        return;
      }

      // Double check that the heading is one of the explicitly allowed values
      if (!FormUtils.ALLOWED_HEADINGS.contains(selectedHeading)) {
        _showError(scaffoldMessenger,
            'Invalid heading value. Please select one of the allowed options.');
        return;
      }

      if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) {
        _showError(scaffoldMessenger, 'Store image is required.');
        return;
      }

      final storeDataObj = Data(
        id: store?.id ?? '',
        name: nameController.text.trim(),
        trackingUrl: trackingUrlController.text.trim(),
        shortDescription: shortDescriptionController.text.trim(),
        longDescription: longDescriptionController.text.trim(),
        image: StoreImage(
          url: uploadedImageUrl,
          alt: imagePickerVM.selectedImageAlt?.trim() ?? 'Store Logo',
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

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Saving store...')),
      );

      final success = store != null
          ? await storeViewModel.updateStore(storeDataObj)
          : await storeViewModel.createStore(storeDataObj);

      scaffoldMessenger.hideCurrentSnackBar();

      if (success) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(store != null
                ? 'Store updated successfully!'
                : 'Store created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _clearFormFields();
        imagePickerVM.clearImage();
      } else {
        _showError(
            scaffoldMessenger,
            storeViewModel.errorMessage ??
                'Failed to save store. Please try again.');
      }
    } catch (e) {
      scaffoldMessenger.hideCurrentSnackBar();
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
