// Updated StoreModel.dart

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

  // When sending data to the backend, use the filtered JSON.
  Map<String, dynamic> toJsonForRequest() => {
        "status": status,
        "data": data.toJsonForRequest(),
      };

  // Optionally, keep the original toJson() if needed for other purposes.
  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  String id;
  String name;
  String trackingUrl;
  String shortDescription;
  String longDescription;
  StoreImage image;
  List<CategoryData> categories;
  Seo seo;
  String language;
  bool isTopStore;
  bool isEditorsChoice;
  String heading;

  Data({
    required this.id,
    required this.name,
    required this.trackingUrl,
    required this.shortDescription,
    required this.longDescription,
    required this.image,
    required this.categories,
    required this.seo,
    required this.language,
    required this.isTopStore,
    required this.isEditorsChoice,
    required this.heading,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        name: json["name"],
        trackingUrl: json["trackingUrl"],
        shortDescription: json["short_description"],
        longDescription: json["long_description"],
        image: StoreImage.fromJson(json["image"]),
        categories: (json["categories"] as List<dynamic>).map((x) {
          return x is String
              ? CategoryData(id: x, name: '')
              : CategoryData.fromJson(x);
        }).toList(),
        seo: Seo.fromJson(json["seo"]),
        language: json["language"],
        isTopStore: json["isTopStore"] ?? false,
        isEditorsChoice: json["isEditorsChoice"] ?? false,
        heading: json["heading"] ?? 'Coupons & Promo Codes',
      );

  // Full serialization (if needed for internal use)
  Map<String, dynamic> toJson() => {
        "name": name,
        "trackingUrl": trackingUrl,
        "short_description": shortDescription,
        "long_description": longDescription,
        "image": image.toJson(),
        "categories": categories.map((x) => x.id).toList(), // ✅ Corrected here
        "seo": seo.toJson(),
        "language": language,
        "_id": id,
        // The following fields are maintained internally:
        // "createdAt": createdAt.toIso8601String(),
        // "updatedAt": updatedAt.toIso8601String(),
        // "slug": slug,
        // "__v": v,
        "isTopStore": isTopStore,
        "isEditorsChoice": isEditorsChoice,
        "heading": _cleanHeading(heading),
      };

  // New method: builds JSON including the id while excluding unnecessary backend-managed fields.
  Map<String, dynamic> toJsonForRequest() {
    return {
      "id": id,
      "name": name,
      "trackingUrl": trackingUrl,
      "short_description": shortDescription,
      "long_description": longDescription,
      "image": image.toJson(),
      "categories": categories.map((x) => x.toJson()).toList(),
      "seo": seo.toJson(),
      "language": language,
      "isTopStore": isTopStore,
      "isEditorsChoice": isEditorsChoice,
      "heading": _cleanHeading(heading),
    };
  }

  // Helper method to clean heading values and prevent HTML encoding
  String _cleanHeading(String headingValue) {
    return headingValue
        .replaceAll('&amp;', '&') // Convert encoded
        .replaceAll(' ', ' ') // Remove invisible non-breaking space
        .replaceAll('&', '&') // Stop future encoding
        .trim();
  }
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
