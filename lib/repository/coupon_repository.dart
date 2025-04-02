import 'package:flutter/foundation.dart';
import 'package:coupon_admin_panel/data/network/base_api_services.dart';
import 'package:coupon_admin_panel/data/network/network_api_services.dart';
import 'package:coupon_admin_panel/model/coupon_model.dart';
import 'package:coupon_admin_panel/res/app_url.dart';

class CouponRepository {
  final BaseAPiServices _apiServices = NetworkApiServices();

// createCoupon
Future<dynamic> createCoupon(Map<String, dynamic> data) async {
  try {
    // Determine if "Code" was selected (active is false)
    final isCodeSelected = data['active'] == false;

    // Conditional coupon code check
    if (isCodeSelected && (data['code'] == null || data['code'].toString().isEmpty)) {
      throw Exception('Coupon code is required because "Code" was selected');
    }

    // Always required fields
    if (data['offerDetails'] == null || data['offerDetails'].toString().isEmpty) {
      throw Exception('Offer details are required');
    }

    if (data['store'] == null || data['store'].toString().isEmpty) {
      throw Exception('Store ID is required');
    }

    // Set defaults if not provided
    data['active'] ??= true;
    data['featuredForHome'] ??= false;

    // Log payload for debugging
    if (kDebugMode) {
      print("Sending payload to create coupon: $data");
    }

    // Send POST request
    final response = await _apiServices.getPostApiResponse(
      AppUrl.createCouponUrl,
      data,
    );

    // Log response for debugging
    if (kDebugMode) {
      print("Coupon creation response: $response");
    }

    return response;
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print("Error creating coupon: $e");
      print("StackTrace: $stackTrace");
    }
    rethrow;
  }
}

// fetchCoupons
  Future<List<CouponData>> fetchCoupons() async {
    try {
      if (kDebugMode) {
        print("Fetching coupons from URL: ${AppUrl.getCouponsUrl}");
      }

      final Map<String, dynamic> response =
          await _apiServices.getGetApiResponse(AppUrl.getCouponsUrl);

      if (kDebugMode) {
        print("Coupon API response status: ${response['status']}");
        if (response['data'] != null) {
          print("Number of coupons received: ${response['data'].length}");
        } else {
          print("No coupon data received or data is null");
          print("Complete response: $response");
        }
      }

      if (response['status'] == 'success' && response['data'] != null) {
        List<dynamic> couponData = response['data'];
        List<CouponData> coupons = [];

        for (var couponJson in couponData) {
          try {
            // Handle potential missing fields with default values
            if (!couponJson.containsKey('offerDetails')) {
              couponJson['offerDetails'] = '';
            }
            if (!couponJson.containsKey('active')) {
              couponJson['active'] = true;
            }
            if (!couponJson.containsKey('isValid')) {
              couponJson['isValid'] = true;
            }
            if (!couponJson.containsKey('featuredForHome')) {
              couponJson['featuredForHome'] = false;
            }
            if (!couponJson.containsKey('hits')) {
              couponJson['hits'] = 0;
            }

            // Validate store data is properly structured
            if (couponJson['store'] != null) {
              var storeData = couponJson['store'];
              if (storeData is String) {
                // If store is just an ID string, convert to proper structure
                couponJson['store'] = {
                  '_id': storeData,
                  'name': 'Unknown Store',
                  'image': '',
                };
              }
            } else {
              // If store is missing, provide a placeholder
              couponJson['store'] = {
                '_id': '',
                'name': 'Missing Store',
                'image': '',
              };
            }

            final coupon = CouponData.fromJson(couponJson);
            coupons.add(coupon);

            if (kDebugMode) {
              print(
                  "Successfully parsed coupon: ${coupon.id} - ${coupon.code}");
            }
          } catch (e) {
            if (kDebugMode) {
              print("Error parsing coupon: $e");
              print("Problematic coupon data: $couponJson");
            }
          }
        }

        if (kDebugMode) {
          print("Successfully parsed ${coupons.length} coupons");
        }

        return coupons;
      } else {
        final errorMessage = response['message'] ?? 'Unknown error';
        if (kDebugMode) {
          print("Failed to load coupons: $errorMessage");
        }
        throw Exception("Failed to load coupons: $errorMessage");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching coupons: $e");
      }
      rethrow;
    }
  }

//deleteCoupon
  Future<void> deleteCoupon(String couponId) async {
    try {
      if (kDebugMode) {
        print("Deleting coupon with ID: $couponId");
      }

      final response = await _apiServices
          .getDeleteApiResponse(AppUrl.deleteCouponUrl(couponId));

      if (kDebugMode) {
        print("Delete coupon response: $response");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting coupon: $e");
      }
      rethrow;
    }
  }
  
//updateCoupon
  Future<dynamic> updateCoupon(Map<String, dynamic> data) async {
    try {
      // Ensure all required fields are included
      if (data['store'] != null && data['store'] is Map) {
        // Make sure we're sending storeId properly
        final storeData = data['store'];
        if (!storeData.containsKey('_id') && storeData.containsKey('id')) {
          storeData['_id'] = storeData['id'];
        }
        // Ensure store name is not empty
        if (storeData['name'] == null || storeData['name'].toString().isEmpty) {
          storeData['name'] = 'Unknown Store';
        }
      }

      if (kDebugMode) {
        print("Updating coupon with data: $data");
      }

      dynamic response = await _apiServices.getPutApiResponse(
          AppUrl.updateCouponUrl(data['_id']), data);

      if (kDebugMode) {
        print("Update coupon response: $response");
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error updating coupon: $e");
      }
      rethrow;
    }
  }
}
