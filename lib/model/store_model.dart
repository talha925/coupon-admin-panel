//
//     final storeModel = storeModelFromJson(jsonString);

import 'dart:convert';

StoreModel storeModelFromJson(String str) =>
    StoreModel.fromJson(json.decode(str));

String storeModelToJson(StoreModel data) => json.encode(data.toJson());

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
  StoreImage image; // ✅ Fix: Replaced `Image` with `StoreImage`
  List<String> categories;
  Seo seo;
  String language;
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String slug;
  int v;

  Data({
    required this.name,
    required this.directUrl,
    required this.trackingUrl,
    required this.shortDescription,
    required this.longDescription,
    required this.image,
    required this.categories,
    required this.seo,
    required this.language,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.slug,
    required this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        directUrl: json["directUrl"],
        trackingUrl: json["trackingUrl"],
        shortDescription: json["short_description"],
        longDescription: json["long_description"],
        image: StoreImage.fromJson(json["image"]),
        categories: List<String>.from(json["categories"].map((x) => x)),
        seo: Seo.fromJson(json["seo"]),
        language: json["language"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        slug: json["slug"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "directUrl": directUrl,
        "trackingUrl": trackingUrl,
        "short_description": shortDescription,
        "long_description": longDescription,
        "image": image.toJson(),
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "seo": seo.toJson(),
        "language": language,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "slug": slug,
        "__v": v,
      };
}

// ✅ Fixed `StoreImage` class name conflict
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
