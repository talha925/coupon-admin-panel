import 'package:flutter/foundation.dart';
import 'package:coupon_admin_panel/data/network/base_api_services.dart';
import 'package:coupon_admin_panel/data/network/network_api_services.dart';
import 'package:coupon_admin_panel/model/coupon_model.dart';
import 'package:coupon_admin_panel/res/app_url.dart';

class CouponRepository {
  final BaseAPiServices _apiServices = NetworkApiServices();

  Future<dynamic> createCoupon(Map<String, dynamic> data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.createCouponUrl, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      rethrow;
    }
  }

  Future<List<Datum>> fetchCoupons() async {
    try {
      final Map<String, dynamic> response =
          await _apiServices.getGetApiResponse(AppUrl.getCouponsUrl);

      if (response['status'] == 'success') {
        List<dynamic> couponData = response['data'];
        List<Datum> coupons =
            couponData.map((couponJson) => Datum.fromJson(couponJson)).toList();

        return coupons;
      } else {
        throw Exception("Failed to load coupons");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      rethrow;
    }
  }

  Future<void> deleteCoupon(String couponId) async {
    try {
      await _apiServices.getDeleteApiResponse(AppUrl.deleteCouponUrl(couponId));
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      rethrow;
    }
  }

  Future<void> updateCoupon(Map<String, dynamic> data) async {
    try {
      await _apiServices.getPutApiResponse(
          AppUrl.updateCouponUrl(data['_id']), data);
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      rethrow;
    }
  }
}
