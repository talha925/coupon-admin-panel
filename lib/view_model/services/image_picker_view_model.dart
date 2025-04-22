// lib/view_model/services/image_picker_view_model.dart
import 'dart:io' show Platform;

export 'image_picker_view_model_stub.dart'
    if (dart.library.html) 'image_picker_view_model_web.dart'
    if (dart.library.io) 'image_picker_view_model_windows.dart';
// Temporary debug code

void debugPlatform() {
  print('Running on: ${Platform.operatingSystem}');
  print('dart.library.io: ${identical(1, 1.0)}'); // Should be true on native
}
