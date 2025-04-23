// lib/services/image_service.dart (Assuming this path based on usage)

import 'dart:convert';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ImageService {
  // Define your base URL - using localhost for example
  // final String _baseUrl = 'https://coupon-app-backend.vercel.app/api/upload';
  final String _baseUrl = 'http://localhost:5000/api/upload';

  /// Uploads an image to the server and returns the image URL.
  Future<String> uploadImageToS3(Uint8List imageBytes, String imageName) async {
    final uri = Uri.parse(_baseUrl); // Use base URL
    debugPrint('Uploading image to: $uri');
    debugPrint(
        'Image name: $imageName, Image size: ${imageBytes.lengthInBytes} bytes');

    if (imageBytes.isEmpty) {
      debugPrint('Error: Empty image data provided to upload.');
      throw Exception('Empty image data');
    }
    // Optional: Add size check if needed (e.g., 5MB)
    if (imageBytes.lengthInBytes > 5 * 1024 * 1024) {
      debugPrint('Error: Image size exceeds limit.');
      throw Exception('Image size exceeds 5MB limit');
    }

    try {
      var request = http.MultipartRequest('POST', uri);

      request.files.add(
        http.MultipartFile.fromBytes(
          'image', // Backend expects the file under the key 'image'
          imageBytes,
          filename: imageName,
          contentType: MediaType(
              'image',
              imageName
                  .split('.')
                  .last), // Determine content type from extension
        ),
      );

      // Optional: Add other fields if your backend needs them
      // request.fields['userId'] = 'someUserId';

      debugPrint('Sending upload request...');
      var response = await request.send().timeout(
          // Increased timeout for potentially large uploads
          const Duration(seconds: 60), onTimeout: () {
        debugPrint('Error: Upload request timed out.');
        throw Exception('Upload timed out after 60 seconds');
      });

      var responseData = await response.stream.bytesToString();
      debugPrint('Upload response status: ${response.statusCode}');
      debugPrint('Upload response data: $responseData');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Allow 201 Created
        var jsonResponse = json.decode(responseData);
        if (jsonResponse['imageUrl'] != null) {
          debugPrint(
              'Upload successful. Image URL: ${jsonResponse['imageUrl']}');
          return jsonResponse['imageUrl'];
        } else {
          debugPrint('Error: Upload response missing imageUrl.');
          throw Exception('Upload response missing imageUrl field.');
        }
      } else {
        debugPrint('Error: Upload failed.');
        // Try to parse error message from backend response if available
        String errorMessage =
            'Upload failed with status ${response.statusCode}.';
        try {
          var errorJson = json.decode(responseData);
          errorMessage +=
              ' ${errorJson['message'] ?? errorJson['error'] ?? ''}';
        } catch (_) {
          // Ignore if response is not JSON or doesn't contain expected error fields
          errorMessage += ' Response: $responseData';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error during image upload: $e');
      // Rethrow a more specific exception or the original one
      throw Exception('Image upload failed: $e');
    }
  }

  /// Deletes an image from the server (S3).
  Future<void> deleteImage(String imageUrl) async {
    // Ensure imageUrl is not empty or null before proceeding
    if (imageUrl.isEmpty) {
      debugPrint('Error: Empty image URL provided for deletion.');
      throw Exception('Image URL cannot be empty for deletion.');
    }

    final uri =
        Uri.parse('$_baseUrl/delete-image'); // Append specific delete endpoint
    debugPrint('Deleting image: $imageUrl from $uri');

    try {
      final response = await http.post(
        uri,
        body: json.encode({'imageUrl': imageUrl}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 20), // Shorter timeout for delete
          onTimeout: () {
        debugPrint('Error: Delete request timed out.');
        throw Exception('Delete timed out after 20 seconds');
      });

      debugPrint('Delete response status: ${response.statusCode}');
      debugPrint('Delete response body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        // Allow 204 No Content
        // Try to parse error message
        String errorMessage =
            'Delete failed with status ${response.statusCode}.';
        try {
          var errorJson = json.decode(response.body);
          errorMessage +=
              ' ${errorJson['message'] ?? errorJson['error'] ?? ''}';
        } catch (_) {
          errorMessage += ' Response: ${response.body}';
        }
        throw Exception(errorMessage);
      }
      debugPrint('Image deleted successfully (or already deleted).');
    } catch (e) {
      debugPrint('Error during image deletion: $e');
      throw Exception('Failed to delete image: $e');
    }
  }
}
