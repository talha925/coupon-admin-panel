// import 'package:coupon_admin_panel/data/network/base_api_services.dart';
// import 'package:coupon_admin_panel/data/network/network_api_services.dart';
// import 'package:coupon_admin_panel/res/app_url.dart';

// /// AuthRepository handles the authentication-related API calls.
// class AuthRepository {
//   // BaseAPIservices is an abstract class that defines the structure of the API service.
//   // Here, we instantiate it with NetworkApiServices, which is the concrete implementation.
//   final BaseAPiServices _apiServices = NetworkApiServices();

//   /// loginApi sends a POST request to the login endpoint with the provided data.
//   /// [data] is the payload (e.g., username and password) to be sent in the request body.
//   /// Returns the API response if successful, otherwise throws an error.
//   Future<dynamic> loginApi(dynamic data) async {
//     try {
//       // Sends a POST request to the login URL with the provided data.
//       dynamic response =
//           await _apiServices.getPostApiResponse(AppUrl.loginUrl, data);
//       return response;
//     } catch (e) {
//       // Throws an error if something goes wrong during the API call.
//       rethrow;
//     }
//   }

//   /// signUpApi sends a POST request to the registration endpoint with the provided data.
//   /// [data] is the payload (e.g., user details) to be sent in the request body.
//   /// Returns the API response if successful, otherwise throws an error.
//   Future<dynamic> signUpApi(dynamic data) async {
//     try {
//       // Sends a POST request to the registration URL with the provided data.
//       dynamic response =
//           await _apiServices.getPostApiResponse(AppUrl.registerUrl, data);
//       return response;
//     } catch (e) {
//       // Throws an error if something goes wrong during the API call.
//       rethrow;
//     }
//   }
// }
