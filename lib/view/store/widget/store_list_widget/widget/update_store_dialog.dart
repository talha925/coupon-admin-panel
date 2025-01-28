import 'package:coupon_admin_panel/res/components/custom_textfild_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/services/image_picker_view_model_web.dart';
import 'package:coupon_admin_panel/model/store_model.dart';

class UpdateStoreDialog extends StatelessWidget {
  final Data store;

  const UpdateStoreDialog({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: store.name);
    final websiteController = TextEditingController(text: store.website);
    final descriptionController =
        TextEditingController(text: store.shortDescription);

    return AlertDialog(
      title: const Text('Update Store'),
      content: SingleChildScrollView(
        child: Consumer<ImagePickerViewModel>(
          builder: (context, imagePickerViewModel, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                  controller: nameController,
                  labelText: 'Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a store name';
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  controller: websiteController,
                  labelText: 'Website',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a website';
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  controller: descriptionController,
                  labelText: 'Description',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                imagePickerViewModel.selectedImageName != null
                    ? ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxHeight: 200, maxWidth: 200),
                        child: Image.network(
                            imagePickerViewModel.selectedImageName!),
                      )
                    : (store.image.url.isNotEmpty
                        ? ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxHeight: 200, maxWidth: 200),
                            child: Image.network(store.image.url),
                          )
                        : const Icon(Icons.store)),
                ElevatedButton(
                  onPressed: () => imagePickerViewModel.pickImage(),
                  child: const Text('Pick Image'),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Update'),
          onPressed: () {
            // final updatedStore = Data(
            //   id: store.id,
            //   name: nameController.text,
            //   website: websiteController.text,
            //   description: descriptionController.text,
            //   image: Provider.of<ImagePickerViewModel>(context, listen: false)
            //           .imageName ??
            //       store.image, // Use picked image or existing one
            //   coupons: store.coupons, categories: [], v: 0,
            // );

            // Provider.of<StoreViewModel>(context, listen: false)
            //     .updateStore(updatedStore);
            // Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
