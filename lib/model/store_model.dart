// // To parse this JSON data, do
// //
// //     final storeModel = storeModelFromJson(jsonString);

// import 'dart:convert';

// StoreModel storeModelFromJson(String str) =>
//     StoreModel.fromJson(json.decode(str));

// String storeModelToJson(StoreModel data) => json.encode(data.toJson());

// class StoreModel {
//   String status;
//   List<Data> data;

//   StoreModel({
//     required this.status,
//     required this.data,
//   });

//   factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
//         status: json["status"],
//         data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class Data {
//   String slug;
//   String id;
//   String name;
//   String website;
//   String shortDescription;
//   String longDescription;
//   String image;
//   String imageAlt; // Ensure alt text is included
//   Seo seo;
//   List<dynamic> categories;
//   List<Coupon> coupons;
//   String language;
//   bool topStore;
//   bool editorsChoice;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;

//   Data({
//     required this.slug,
//     required this.id,
//     required this.name,
//     required this.website,
//     required this.shortDescription,
//     required this.longDescription,
//     required this.image,
//     required this.imageAlt,
//     required this.seo,
//     required this.categories,
//     required this.coupons,
//     required this.language,
//     required this.topStore,
//     required this.editorsChoice,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["_id"],
//         name: json["name"],
//         website: json["website"],
//         shortDescription: json["short_description"],
//         longDescription: json["long_description"],
//         image: json["image"]["url"], // Ensure URL is nested
//         imageAlt: json["image"]["alt"] ?? "Default Alt Text", // Provide default
//         seo: Seo.fromJson(json["seo"]),
//         categories: List<dynamic>.from(json["categories"].map((x) => x)),
//         coupons: json["coupons"] == null
//             ? []
//             : List<Coupon>.from(json["coupons"].map((x) => Coupon.fromJson(x))),
//         language: json["language"],
//         topStore: json["top_store"] ?? false,
//         editorsChoice: json["editors_choice"] ?? false,
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         slug: json["slug"],
//         v: json["__v"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "name": name,
//         "website": website,
//         "short_description": shortDescription,
//         "long_description": longDescription,
//         "image": {
//           "url": image,
//           "alt": imageAlt, // Serialize alt text properly
//         },
//         "seo": seo.toJson(),
//         "categories": List<dynamic>.from(categories.map((x) => x)),
//         "coupons": List<dynamic>.from(coupons.map((x) => x.toJson())),
//         "language": language,
//         "top_store": topStore,
//         "editors_choice": editorsChoice,
//         "createdAt": createdAt.toIso8601String(),
//         "updatedAt": updatedAt.toIso8601String(),
//         "slug": slug,
//         "__v": v,
//       };
// }

// class Coupon {
//   String id;
//   String code;
//   String description;
//   int discount;
//   DateTime expirationDate;
//   String affiliateLink;

//   Coupon({
//     required this.id,
//     required this.code,
//     required this.description,
//     required this.discount,
//     required this.expirationDate,
//     required this.affiliateLink,
//   });

//   factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
//         id: json["_id"],
//         code: json["code"],
//         description: json["description"],
//         discount: json["discount"],
//         expirationDate: DateTime.parse(json["expirationDate"]),
//         affiliateLink: json["affiliateLink"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "code": code,
//         "description": description,
//         "discount": discount,
//         "expirationDate": expirationDate.toIso8601String(),
//         "affiliateLink": affiliateLink,
//       };
// }

// class Seo {
//   String metaTitle;
//   String metaDescription;
//   String metaKeywords;

//   Seo({
//     required this.metaTitle,
//     required this.metaDescription,
//     required this.metaKeywords,
//   });

//   factory Seo.fromJson(Map<String, dynamic> json) => Seo(
//         metaTitle: json["meta_title"],
//         metaDescription: json["meta_description"],
//         metaKeywords: json["meta_keywords"],
//       );

//   Map<String, dynamic> toJson() => {
//         "meta_title": metaTitle,
//         "meta_description": metaDescription,
//         "meta_keywords": metaKeywords,
//       };
// }
// To parse this JSON data, do
//
//     final storeModel = storeModelFromJson(jsonString);

// import 'dart:convert';

// StoreModel storeModelFromJson(String str) =>
//     StoreModel.fromJson(json.decode(str));

// String storeModelToJson(StoreModel data) => json.encode(data.toJson());

// class StoreModel {
//   String status;
//   List<Data> data;

//   StoreModel({
//     required this.status,
//     required this.data,
//   });

//   factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
//         status: json["status"],
//         data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class Data {
//   String slug;
//   String id;
//   String name;
//   String website;
//   String shortDescription;
//   String longDescription;
//   String image;
//   Seo seo;
//   List<dynamic> categories;
//   List<Coupon> coupons;
//   String language;
//   bool topStore;
//   bool editorsChoice;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;

//   Data({
//     required this.slug,
//     required this.id,
//     required this.name,
//     required this.website,
//     required this.shortDescription,
//     required this.longDescription,
//     required this.image,
//     required this.seo,
//     required this.categories,
//     required this.coupons,
//     required this.language,
//     required this.topStore,
//     required this.editorsChoice,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["_id"],
//         name: json["name"],
//         website: json["website"],
//         shortDescription: json["short_description"],
//         longDescription: json["long_description"],
//         image: json["image"],
//         seo: Seo.fromJson(json["seo"]),
//         categories: List<dynamic>.from(json["categories"].map((x) => x)),
//         coupons: json["coupons"] == null
//             ? []
//             : List<Coupon>.from(json["coupons"].map((x) => Coupon.fromJson(x))),
//         language: json["language"],
//         topStore: json["top_store"] ?? false, // Default to false if null
//         editorsChoice:
//             json["editors_choice"] ?? false, // Default to false if null
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         slug: json["slug"],
//         v: json["__v"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "name": name,
//         "website": website,
//         "short_description": shortDescription,
//         "long_description": longDescription,
//         "image": image,
//         "seo": seo.toJson(),
//         "categories": List<dynamic>.from(categories.map((x) => x)),
//         "coupons": List<dynamic>.from(coupons.map((x) => x.toJson())),
//         "language": language,
//         "top_store": topStore,
//         "editors_choice": editorsChoice,
//         "createdAt": createdAt.toIso8601String(),
//         "updatedAt": updatedAt.toIso8601String(),
//         "slug": slug,
//         "__v": v,
//       };
// }

// class Coupon {
//   String id;
//   String code;
//   String description;
//   int discount;
//   DateTime expirationDate;
//   String affiliateLink;

//   Coupon({
//     required this.id,
//     required this.code,
//     required this.description,
//     required this.discount,
//     required this.expirationDate,
//     required this.affiliateLink,
//   });

//   factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
//         id: json["_id"],
//         code: json["code"],
//         description: json["description"],
//         discount: json["discount"],
//         expirationDate: DateTime.parse(json["expirationDate"]),
//         affiliateLink: json["affiliateLink"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "code": code,
//         "description": description,
//         "discount": discount,
//         "expirationDate": expirationDate.toIso8601String(),
//         "affiliateLink": affiliateLink,
//       };
// }

// class Seo {
//   String metaTitle;
//   String metaDescription;
//   String metaKeywords;

//   Seo({
//     required this.metaTitle,
//     required this.metaDescription,
//     required this.metaKeywords,
//   });

//   factory Seo.fromJson(Map<String, dynamic> json) => Seo(
//         metaTitle: json["meta_title"],
//         metaDescription: json["meta_description"],
//         metaKeywords: json["meta_keywords"],
//       );

//   Map<String, dynamic> toJson() => {
//         "meta_title": metaTitle,
//         "meta_description": metaDescription,
//         "meta_keywords": metaKeywords,
//       };
// }

// To parse this JSON data, do
//
//     final storeModel = storeModelFromJson(jsonString);

import 'dart:convert';

// Decode JSON to StoreModel
StoreModel storeModelFromJson(String str) =>
    StoreModel.fromJson(json.decode(str));

// Encode StoreModel to JSON
String storeModelToJson(StoreModel data) => json.encode(data.toJson());

// StoreModel Class
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

// Data Class
class Data {
  String name;
  String website;
  String shortDescription;
  String longDescription;
  StoreImage image; // Renamed to StoreImage
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
    required this.website,
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
        website: json["website"],
        shortDescription: json["short_description"],
        longDescription: json["long_description"],
        image: StoreImage.fromJson(json["image"]), // Updated reference
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
        "website": website,
        "short_description": shortDescription,
        "long_description": longDescription,
        "image": image.toJson(), // Updated reference
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

// StoreImage Class (Previously Image)
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

// Seo Class
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
