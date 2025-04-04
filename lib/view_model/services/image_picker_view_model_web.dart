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

  /// ✅ Auto-set Alt Text from Store Name
  void setStoreNameForAltText(String storeName) {
    _selectedImageAlt = storeName;
    notifyListeners();
  }

  /// Picks an image using the file picker.
  Future<void> pickImage() async {
    try {
      debugPrint('Opening file picker...');
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files == null || files.isEmpty) {
          _setErrorMessage('No file selected.');
          debugPrint('Error: $_errorMessage');
          return;
        }

        final reader = html.FileReader();
        reader.readAsArrayBuffer(files[0]);
        reader.onLoadEnd.listen((e) {
          try {
            _selectedImageBytes = reader.result as Uint8List;
            _selectedImageName = files[0].name;
            _errorMessage = null;
            notifyListeners();
          } catch (error) {
            _setErrorMessage('Failed to read the selected image.');
            debugPrint('Error: $_errorMessage');
          }
        });
      });
    } catch (error) {
      _setErrorMessage('Error picking image: $error');
      debugPrint('Error: $_errorMessage');
    }
  }

  /// Uploads the selected image to the backend and returns the image URL.
  Future<String> uploadImageToS3() async {
    try {
      if (_selectedImageBytes == null || _selectedImageName == null) {
        throw Exception('No image selected');
      }
      // final uri = Uri.parse('https://coupon-app-backend.vercel.app/api/upload');

      final uri = Uri.parse('http://localhost:5000/api/upload');
      var request = http.MultipartRequest('POST', uri);

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          _selectedImageBytes!,
          filename: _selectedImageName!,
          contentType: MediaType('image', _selectedImageName!.split('.').last),
        ),
      );

      debugPrint('Sending image upload request...');
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        debugPrint('Image uploaded successfully: $responseData');
        var jsonResponse = json.decode(responseData);
        return jsonResponse['imageUrl'];
      } else {
        var errorResponse = json.decode(responseData);
        debugPrint('Error response: $errorResponse');
        throw Exception(
            'Failed to upload image. Status Code: ${response.statusCode}, Error: ${errorResponse['error']}');
      }
    } catch (error) {
      _setErrorMessage('Image upload failed: $error');
      debugPrint('Image Upload Error: $error');
      rethrow;
    }
  }

  /// Clears the selected image and resets the state.
  void clearImage() {
    _selectedImageBytes = null;
    _selectedImageName = null;
    _errorMessage = null;
    _selectedImageAlt = null;
    notifyListeners();
  }

  /// Sets the error message and updates the UI.
  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
