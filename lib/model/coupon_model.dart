// To parse this JSON data, do
//
//     final couponModel = couponModelFromJson(jsonString);

import 'dart:convert';

CouponModel couponModelFromJson(String str) =>
    CouponModel.fromJson(json.decode(str));

String couponModelToJson(CouponModel data) => json.encode(data.toJson());

class CouponModel {
  String status;
  List<CouponData> data;
  Metadata metadata;

  CouponModel({
    required this.status,
    required this.data,
    required this.metadata,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        status: json["status"],
        data: List<CouponData>.from(
            json["data"].map((x) => CouponData.fromJson(x))),
        metadata: Metadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "metadata": metadata.toJson(),
      };
}

class CouponData {
  String id;
  String offerDetails;
  String code;
  bool active;
  bool isValid;
  bool featuredForHome;
  int hits;
  DateTime? lastAccessed;
  String storeId;

  CouponData({
    required this.id,
    required this.offerDetails,
    required this.code,
    required this.active,
    required this.isValid,
    required this.featuredForHome,
    required this.hits,
    required this.lastAccessed,
    required this.storeId,
  });
  CouponData copyWith({
    String? id,
    String? offerDetails,
    String? code,
    bool? active,
    bool? isValid,
    bool? featuredForHome,
    int? hits,
    DateTime? lastAccessed,
    String? storeId,
  }) {
    return CouponData(
      id: id ?? this.id,
      offerDetails: offerDetails ?? this.offerDetails,
      code: code ?? this.code,
      active: active ?? this.active,
      isValid: isValid ?? this.isValid,
      featuredForHome: featuredForHome ?? this.featuredForHome,
      hits: hits ?? this.hits,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      storeId: storeId ?? this.storeId,
    );
  }

  static String _validateStoreId(dynamic storeField) {
    if (storeField == null) {
      throw FormatException('Store ID is missing in coupon data');
    }
    if (storeField is String) return storeField;
    if (storeField is Map) return storeField['_id'] ?? '';
    return storeField.toString();
  }

  factory CouponData.fromJson(Map<String, dynamic> json) => CouponData(
        id: json["_id"],
        offerDetails: json["offerDetails"],
        code: json["code"],
        active: json["active"],
        isValid: json["isValid"],
        featuredForHome: json["featuredForHome"],
        hits: json["hits"],
        lastAccessed: json["lastAccessed"] == null
            ? null
            : DateTime.parse(json["lastAccessed"]),
        storeId: _validateStoreId(json["store"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "offerDetails": offerDetails,
        "code": code,
        "active": active,
        "isValid": isValid,
        "featuredForHome": featuredForHome,
        "hits": hits,
        "lastAccessed": lastAccessed?.toIso8601String(),
        "storeId": storeId,
      };
}

class Metadata {
  int totalCoupons;
  int currentPage;
  int totalPages;

  Metadata({
    required this.totalCoupons,
    required this.currentPage,
    required this.totalPages,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        totalCoupons: json["totalCoupons"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "totalCoupons": totalCoupons,
        "currentPage": currentPage,
        "totalPages": totalPages,
      };
}
