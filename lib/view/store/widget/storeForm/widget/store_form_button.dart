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
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSubmitting,
      builder: (context, submitting, child) {
        return submitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  await _submitStore(context);
                },
                child: const Text('Create Store'),
              );
      },
    );
  }

  Future<void> _submitStore(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      Utils.toastMessage('Please fill in all required fields.');
      return;
    }

    isSubmitting.value = true; // Start loading state

    final imagePickerViewModel =
        Provider.of<ImagePickerViewModel>(context, listen: false);

    // ✅ Set the alt text to Store Name
    imagePickerViewModel.selectedImageAlt = nameController.text.trim();

    String? uploadedImageUrl;
    try {
      if (imagePickerViewModel.selectedImageBytes != null) {
        uploadedImageUrl = await imagePickerViewModel.uploadImageToS3();
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
      Utils.toastMessage('Error uploading image. Please try again.');
      isSubmitting.value = false;
      return;
    }

    if (!_validateFields(uploadedImageUrl)) {
      Utils.toastMessage('Please fill in all required fields correctly.');
      isSubmitting.value = false;
      return;
    }

    final store = Data(
      id: '',
      name: nameController.text.trim(),
      directUrl: directUrlController.text.trim(),
      trackingUrl: trackingUrlController.text.trim(),
      image: StoreImage(
        url: uploadedImageUrl ?? '',
        alt: imagePickerViewModel.selectedImageAlt?.trim() ?? 'Default Alt Text',
      ),
      seo: Seo(
        metaTitle: metaTitleController.text.trim(),
        metaDescription: metaDescriptionController.text.trim(),
        metaKeywords: metaKeywordsController.text.trim(),
      ),
      categories: selectedCategory != null ? [selectedCategory!] : [],
      language: language,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      v: 0,
      shortDescription: shortDescriptionController.text.trim(),
      longDescription: longDescriptionController.text.trim(),
      slug: nameController.text.trim(),
    );

    try {
      await Provider.of<StoreViewModel>(context, listen: false).createStore(store);
      Utils.toastMessage('Store created successfully!');

      // ✅ Clear Form Fields After Successful Submission
      _clearFormFields();

      // ✅ Also Clear Selected Image in Image Picker
      imagePickerViewModel.clearImage();
    } catch (e) {
      debugPrint('Error creating store: $e');
      Utils.toastMessage('Error creating store. Please try again.');
    } finally {
      isSubmitting.value = false; // Stop loading state
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
  bool _validateFields(String? uploadedImageUrl) {
    if (nameController.text.trim().isEmpty) return false;
    if (directUrlController.text.trim().isEmpty ||
        !Uri.parse(directUrlController.text.trim()).isAbsolute) return false;
    if (trackingUrlController.text.trim().isEmpty ||
        !Uri.parse(trackingUrlController.text.trim()).isAbsolute) return false;
    if (shortDescriptionController.text.trim().isEmpty) return false;
    if (longDescriptionController.text.trim().isEmpty) return false;
    if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) return false;
    return true;
  }
}
