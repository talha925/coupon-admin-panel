// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io'; // For dealing with image files
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';

// class ImagePickerViewModel extends ChangeNotifier {
//   String? _imageUrl;
//   String? get imageUrl => _imageUrl;

//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       try {
//         File imageFile = File(pickedFile.path);
//         Uint8List imageBytes = await imageFile.readAsBytes();
//         String uploadedImageUrl =
//             await _uploadImage(imageBytes, pickedFile.name);
//         print('Uploaded Image URL: $uploadedImageUrl');
//         _imageUrl = uploadedImageUrl;
//       } catch (e) {
//         debugPrint('Error uploading image: $e');
//       }
//       notifyListeners();
//     }
//   }

//   Future<String> _uploadImage(Uint8List imageBytes, String fileName) async {
//     // final uri = Uri.parse('https://coupon-app-backend.vercel.app/api/upload');
//     final uri = Uri.parse('http://localhost:5000/api/upload');
//     // Sending a proper file extension and name
//     var request = http.MultipartRequest('POST', uri);
//     request.files.add(
//       http.MultipartFile.fromBytes(
//         'image',
//         imageBytes,
//         filename: fileName,
//         contentType: MediaType('image', fileName.split('.').last),
//       ),
//     );

//     var response = await request.send();
//     if (response.statusCode == 200) {
//       var responseData = await response.stream.bytesToString();
//       var jsonResponse = json.decode(responseData);
//       if (jsonResponse['imageUrl'] != null) {
//         return jsonResponse['imageUrl'];
//       } else {
//         throw Exception('Image URL missing in the response');
//       }
//     } else {
//       throw Exception(
//           'Failed to upload image. Status code: ${response.statusCode}');
//     }
//   }

//   void clearImage() {
//     _imageUrl = null;
//     notifyListeners();
//   }
// }
