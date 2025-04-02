// Import CategoryData from category_model.dart instead of redefining it
import 'package:coupon_admin_panel/model/category_model.dart';

class StoreModel {
  String status;
  Data data;

  StoreModel({
    required this.status,
    required this.data,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  String name;
  String directUrl;
  String trackingUrl;
  String shortDescription;
  String longDescription;
  StoreImage image;
  List<CategoryData> categories; // Use CategoryData from category_model.dart
  Seo seo;
  String language;
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String slug;
  int v;
  bool isTopStore;
  bool isEditorsChoice;
  String heading;

  Data({
    required this.name,
    required this.directUrl,
    required this.trackingUrl,
    required this.shortDescription,
    required this.longDescription,
    required this.image,
    required this.categories, // List of CategoryData
    required this.seo,
    required this.language,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.slug,
    required this.v,
    required this.isTopStore,
    required this.isEditorsChoice,
    required this.heading,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        directUrl: json["directUrl"],
        trackingUrl: json["trackingUrl"],
        shortDescription: json["short_description"],
        longDescription: json["long_description"],
        image: StoreImage.fromJson(json["image"]),
        categories: (json["categories"] as List<dynamic>).map((x) {
          return x is String
              ? CategoryData(id: x, name: '') // Handle if category is a string
              : CategoryData.fromJson(x); // Otherwise, parse as CategoryData
        }).toList(),
        seo: Seo.fromJson(json["seo"]),
        language: json["language"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        slug: json["slug"],
        v: json["__v"],
        isTopStore: json["isTopStore"] ?? false,
        isEditorsChoice: json["isEditorsChoice"] ?? false,
        heading: json["heading"] ?? 'Coupons & Promo Codes',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "directUrl": directUrl,
        "trackingUrl": trackingUrl,
        "short_description": shortDescription,
        "long_description": longDescription,
        "image": image.toJson(),
        "categories": categories.map((x) => x.toJson()).toList(),
        "seo": seo.toJson(),
        "language": language,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "slug": slug,
        "__v": v,
        "isTopStore": isTopStore,
        "isEditorsChoice": isEditorsChoice,
        "heading": heading,
      };
}

class StoreImage {
  String url;
  String alt;

  StoreImage({
    required this.url,
    required this.alt,
  });

  factory StoreImage.fromJson(Map<String, dynamic> json) => StoreImage(
        url: json["url"],
        alt: json["alt"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "alt": alt,
      };
}

class Seo {
  String metaTitle;
  String metaDescription;
  String metaKeywords;

  Seo({
    required this.metaTitle,
    required this.metaDescription,
    required this.metaKeywords,
  });

  factory Seo.fromJson(Map<String, dynamic> json) => Seo(
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        metaKeywords: json["meta_keywords"],
      );

  Map<String, dynamic> toJson() => {
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "meta_keywords": metaKeywords,
      };
}
