import 'dart:typed_data';

import 'package:flutter/material.dart';

export 'image_picker_view_model_stub.dart'
    if (dart.library.html) 'image_picker_view_model_web.dart'
    if (dart.library.io) 'image_picker_view_model_mobile.dart';

abstract class ImagePickerViewModel extends ChangeNotifier {
  Uint8List? get selectedImageBytes;
  String? get selectedImageName;
  String? get errorMessage;
  String? get selectedImageAlt;

  Future<void> pickImage();
  Future<String> uploadImageToS3();
  void clearImage();

  set selectedImageAlt(String? value);
}
