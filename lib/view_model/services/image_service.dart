import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ImageService {
  /// Uploads an image to the server (S3) and returns the image URL.
  Future<String> uploadImageToS3(Uint8List imageBytes, String imageName) async {
    try {
      if (imageBytes.isEmpty) throw Exception('Empty image data');
      if (imageBytes.lengthInBytes > 5 * 1024 * 1024) {
        throw Exception('Image size exceeds 5MB limit');
      }
      // final uri = Uri.parse(
      //     'https://coupon-app-backend.vercel.app/api/upload/'); // Corrected endpoint
      final uri = Uri.parse('http://localhost:5000/api/upload');
      var request = http.MultipartRequest('POST', uri);

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName,
          contentType: MediaType('image', imageName.split('.').last),
        ),
      );

      var response = await request.send().timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Upload timed out'),
          );

      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseData);
        return jsonResponse['imageUrl'];
      } else {
        throw Exception('Upload failed with status ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Image upload failed: $error');
    }
  }

  /// Deletes an image from the server (S3).
  Future<void> deleteImage(String imageUrl) async {
    try {
      // final uri = Uri.parse(
      //     'https://coupon-app-backend.vercel.app/api/upload/delete-image'); // Corrected endpoint

      final uri = Uri.parse(
          'http://localhost:5000/api/upload/delete-image'); // Corrected endpoint

      final response = await http.post(
        uri,
        body: json.encode({'imageUrl': imageUrl}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Delete timed out'),
      );

      if (response.statusCode != 200) {
        throw Exception('Delete failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }
}
