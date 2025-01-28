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

  const StoreFormButton({
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
    return Consumer<StoreViewModel>(
      builder: (context, storeViewModel, child) {
        return storeViewModel.isSubmitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final imagePickerViewModel =
                        Provider.of<ImagePickerViewModel>(context,
                            listen: false);

                    String? uploadedImageUrl;
                    try {
                      if (imagePickerViewModel.selectedImageBytes != null) {
                        uploadedImageUrl =
                            await imagePickerViewModel.uploadImageToS3();
                      }
                    } catch (e) {
                      Utils.toastMessage('Error uploading image: $e');
                      return;
                    }

                    final store = Data(
                      id: '',
                      name: nameController.text.trim(),
                      website: directUrlController.text.trim(),
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
                      categories:
                          selectedCategory != null ? [selectedCategory!] : [],
                      language: language,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      v: 0,
                      shortDescription: shortDescriptionController.text.trim(),
                      longDescription: longDescriptionController.text.trim(),
                      slug: nameController.text.trim(),
                    );

                    print('Creating store with data: ${store.toJson()}');

                    try {
                      await Provider.of<StoreViewModel>(context, listen: false)
                          .createStore(store);
                    } catch (e) {
                      Utils.toastMessage('Error creating store: $e');
                    }
                  }
                },
                child: const Text('Create Store'),
              );
      },
    );
  }
}
