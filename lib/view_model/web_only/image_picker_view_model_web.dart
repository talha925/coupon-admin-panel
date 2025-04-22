// lib/view_model/services/image_picker_view_model_web.dart
import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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

  Future<void> pickImage() async {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();
    debugPrint('Web: Image picker is triggered');

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files == null || files.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);
      reader.onLoadEnd.listen((_) {
        _selectedImageBytes = reader.result as Uint8List;
        _selectedImageName = files[0].name;
        _errorMessage = null;
        notifyListeners();
      });
    });
  }

  Future<String> uploadImageToS3() async {
    if (_selectedImageBytes == null || _selectedImageName == null) {
      throw Exception("Store image is required");
    }

    final uri = Uri.parse('https://coupon-app-backend.vercel.app/api/upload');
    var request = http.MultipartRequest('POST', uri);

    request.files.add(http.MultipartFile.fromBytes(
      'image',
      _selectedImageBytes!,
      filename: _selectedImageName!,
      contentType: MediaType('image', _selectedImageName!.split('.').last),
    ));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(responseData);
      return jsonResponse['imageUrl'];
    } else {
      final errorJson = json.decode(responseData);
      throw Exception("Image upload failed: ${errorJson['error']}");
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
