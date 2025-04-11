// lib/view_model/services/image_picker_view_model.dart
import 'package:flutter/foundation.dart';

// Conditional export for platform-aware support
export 'image_picker_view_model_stub.dart'
    if (dart.library.html) 'image_picker_view_model_web.dart';
