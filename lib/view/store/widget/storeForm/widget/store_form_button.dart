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
  final Data? store; // ✅ Added store parameter

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
    required this.store, // ✅ Accept store for edit mode
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
                child: Text(store == null
                    ? 'Create Store'
                    : 'Update Store'), // ✅ Change button text
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

    String? uploadedImageUrl =
        store?.image.url; // ✅ Keep existing image if editing

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

    final isEditing = store != null; // ✅ Check if editing

    final storeData = Data(
      id: isEditing ? store!.id : '', // ✅ Keep existing ID for updates
      name: nameController.text.trim(),
      directUrl: directUrlController.text.trim(),
      trackingUrl: trackingUrlController.text.trim(),
      image: StoreImage(
        url: uploadedImageUrl ?? '', // ✅ Keep existing image if no new one
        alt:
            imagePickerViewModel.selectedImageAlt?.trim() ?? 'Default Alt Text',
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
      createdAt: isEditing ? store!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
      v: 0,
      shortDescription: shortDescriptionController.text.trim(),
      longDescription: longDescriptionController.text.trim(),
      slug: nameController.text.trim(),
      isTopStore: store?.isTopStore ?? false,
      isEditorsChoice: store?.isEditorsChoice ?? false,
    );

    try {
      final storeViewModel =
          Provider.of<StoreViewModel>(context, listen: false);

      if (isEditing) {
        await storeViewModel.updateStore(storeData); // ✅ Update existing store
        Utils.toastMessage('Store updated successfully!');
      } else {
        await storeViewModel.createStore(storeData); // ✅ Create new store
        Utils.toastMessage('Store created successfully!');
      }

      _clearFormFields();
      imagePickerViewModel.clearImage();
    } catch (e) {
      debugPrint('Error saving store: $e');
      Utils.toastMessage('Error saving store. Please try again.');
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
