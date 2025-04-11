import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class ImagePickerViewModel extends ChangeNotifier {
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  String? _selectedImageAlt;

  Uint8List? get selectedImageBytes => _selectedImageBytes;
  String? get selectedImageName => _selectedImageName;
  String? get selectedImageAlt => _selectedImageAlt;

  set selectedImageAlt(String? value) {
    _selectedImageAlt = value;
    notifyListeners();
  }

  void setStoreNameForAltText(String storeName) {
    _selectedImageAlt = storeName;
    notifyListeners();
  }

  Future<void> pickImage() async {
    throw UnsupportedError("Image picking not supported on this platform.");
  }

  Future<String> uploadImageToS3() async {
    throw UnsupportedError("Image upload not supported on this platform.");
  }

  void clearImage() {
    _selectedImageBytes = null;
    _selectedImageName = null;
    _selectedImageAlt = null;
    notifyListeners();
  }
}
