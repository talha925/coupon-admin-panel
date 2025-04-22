import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/services/image_picker_view_model.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ImagePickerViewModel>(
      builder: (context, imagePickerViewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: TextEditingController(
                      text: imagePickerViewModel.selectedImageName ??
                          "No file chosen",
                    ),
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "No file chosen",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await imagePickerViewModel.pickImage();
                    } catch (e) {
                      _showErrorDialog(context, "Error picking image: $e");
                    }
                  },
                  child: const Text("Choose File"),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (imagePickerViewModel.errorMessage != null)
              Text(
                imagePickerViewModel.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),

            // ✅ Display Auto-Generated Alt Text
            if (imagePickerViewModel.selectedImageBytes != null)
              TextFormField(
                controller: TextEditingController(
                  text: imagePickerViewModel.selectedImageAlt ??
                      "Auto-generated Store Name",
                ),
                readOnly: true, // Make it non-editable
                decoration: InputDecoration(
                  labelText: "Alt Text (Auto-generated from Store Name)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

            const SizedBox(height: 10),

            if (imagePickerViewModel.selectedImageName != null)
              ElevatedButton(
                onPressed: () {
                  imagePickerViewModel.clearImage();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Clear File"),
              ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
