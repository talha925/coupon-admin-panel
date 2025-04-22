import 'package:flutter/material.dart';

class ImagePickerViewModel extends ChangeNotifier {
  String? get selectedImageAlt => null;
  get selectedImageBytes => null;
  get selectedImageName => null;
  get errorMessage => "Image picking not supported on this platform.";

  Future<void> pickImage() async {
    debugPrint('Stub: Image picking not supported on this platform');
    throw UnsupportedError("Image picking not supported on this platform.");
  }

  Future<String> uploadImageToS3() async {
    throw UnsupportedError("Image uploading not supported on this platform.");
  }

  void clearImage() {
    // Placeholder method for non-web platforms
  }

  set selectedImageAlt(String? value) {
    // Placeholder setter for non-web platforms
  }
}
