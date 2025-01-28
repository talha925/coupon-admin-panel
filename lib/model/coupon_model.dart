// To parse this JSON data, do
//
//     final couponModel = couponModelFromJson(jsonString);

import 'dart:convert';

CouponModel couponModelFromJson(String str) =>
    CouponModel.fromJson(json.decode(str));

String couponModelToJson(CouponModel data) => json.encode(data.toJson());

class CouponModel {
  String status;
  List<Datum> data;

  CouponModel({
    required this.status,
    required this.data,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String code;
  String description;
  int discount;
  DateTime expirationDate;
  Store store;
  String affiliateLink;
  int v;

  Datum({
    required this.id,
    required this.code,
    required this.description,
    required this.discount,
    required this.expirationDate,
    required this.store,
    required this.affiliateLink,
    required this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        code: json["code"],
        description: json["description"],
        discount: json["discount"],
        expirationDate: DateTime.parse(json["expirationDate"]),
        store: Store.fromJson(json["store"]),
        affiliateLink: json["affiliateLink"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "code": code,
        "description": description,
        "discount": discount,
        "expirationDate": expirationDate.toIso8601String(),
        "store": store.toJson(),
        "affiliateLink": affiliateLink,
        "__v": v,
      };
}

class Store {
  String id;
  String name;
  String image;

  Store({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "image": image,
      };
}
