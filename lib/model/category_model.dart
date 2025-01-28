// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  String status;
  List<CategoryData> data;

  CategoryModel({
    required this.status,
    required this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        status: json["status"],
        data: List<CategoryData>.from(
            json["data"].map((x) => CategoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CategoryData {
  String id;
  String name;

  CategoryData({
    required this.id,
    required this.name,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
