// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  bool? status;
  String? msg;
  List<Body>? body;

  CategoryModel({
    this.status,
    this.msg,
    this.body,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    status: json["status"],
    msg: json["msg"],
    body: List<Body>.from(json["body"].map((x) => Body.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "body": List<dynamic>.from(body!.map((x) => x.toJson())),
  };
}

class Body {
  String? catId;
  String? catName;

  Body({
    this.catId,
    this.catName,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    catId: json["cat_id"],
    catName: json["cat_name"],
  );

  Map<String, dynamic> toJson() => {
    "cat_id": catId,
    "cat_name": catName,
  };
}
