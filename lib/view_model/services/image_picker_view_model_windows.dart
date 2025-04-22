import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class ImagePickerViewModel extends ChangeNotifier {
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  String? _errorMessage;
  String? _selectedImageAlt;

  Uint8List? get selectedImageBytes => _selectedImageBytes;
  String? get selectedImageName => _selectedImageName;
  String? get errorMessage => _errorMessage;
  String? get selectedImageAlt => _selectedImageAlt;

  set selectedImageAlt(String? value) {
    _selectedImageAlt = value;
    notifyListeners();
  }

// In image_picker_view_model_windows.dart, update pickImage():
  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // This ensures we get the bytes
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        _selectedImageBytes = file.bytes;
        _selectedImageName = file.name;
        _selectedImageAlt = "Store image: ${file.name.split('.').first}";
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Failed to pick image: ${e.toString()}";
      _selectedImageBytes = null;
      _selectedImageName = null;
      notifyListeners();
      debugPrint('Image picker error: $e');
    }
  }

  Future<String> uploadImageToS3() async {
    if (_selectedImageBytes == null || _selectedImageName == null) {
      throw Exception("Image is required");
    }
    final uri = Uri.parse('https://coupon-app-backend.vercel.app/api/upload');

    // final uri = Uri.parse('http://localhost:5000/api/upload');
    var request = http.MultipartRequest('POST', uri);

    String extension =
        path.extension(_selectedImageName!).replaceFirst('.', '');
    if (extension.isEmpty) extension = 'jpeg';

    request.files.add(http.MultipartFile.fromBytes(
      'image',
      _selectedImageBytes!,
      filename: _selectedImageName!,
      contentType: MediaType('image', extension),
    ));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseData)['imageUrl'];
    } else {
      throw Exception("Upload failed: ${jsonDecode(responseData)['error']}");
    }
  }

  void clearImage() {
    _selectedImageBytes = null;
    _selectedImageName = null;
    _selectedImageAlt = null;
    _errorMessage = null;
    notifyListeners();
  }
}
