import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coupon_admin_panel/view_model/services/image_picker_view_model.dart';

class ImagePickerViewModelImpl extends ImagePickerViewModel {
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  String? _errorMessage;
  String? _selectedImageAlt;

  @override
  Uint8List? get selectedImageBytes => _selectedImageBytes;
  @override
  String? get selectedImageName => _selectedImageName;
  @override
  String? get errorMessage => _errorMessage;
  @override
  String? get selectedImageAlt => _selectedImageAlt;

  @override
  set selectedImageAlt(String? value) {
    _selectedImageAlt = value;
    notifyListeners();
  }

  @override
  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _selectedImageBytes = await pickedFile.readAsBytes();
        _selectedImageName = pickedFile.name;
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Failed to pick image: ${e.toString()}";
      notifyListeners();
    }
  }

  @override
  Future<String> uploadImageToS3() async {
    if (_selectedImageBytes == null || _selectedImageName == null) {
      throw Exception("Image is required");
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
      throw Exception("Image upload failed");
    }
  }

  @override
  void clearImage() {
    _selectedImageBytes = null;
    _selectedImageName = null;
    _selectedImageAlt = null;
    _errorMessage = null;
    notifyListeners();
  }
}
