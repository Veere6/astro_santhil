// To parse this JSON data, do
//
//     final subCategoryModel = subCategoryModelFromJson(jsonString);

import 'dart:convert';

SubCategoryModel subCategoryModelFromJson(String str) => SubCategoryModel.fromJson(json.decode(str));

String subCategoryModelToJson(SubCategoryModel data) => json.encode(data.toJson());

class SubCategoryModel {
  bool? status;
  String? msg;
  List<Body>? body;

  SubCategoryModel({
    this.status,
    this.msg,
    this.body,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
    status: json["status"],
    msg: json["msg"],
    body: json["body"]==null ? null: List<Body>.from(json["body"].map((x) => Body.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "body": List<dynamic>.from(body!.map((x) => x.toJson())),
  };
}

class Body {
  String? subCatId;
  String? catId;
  String? subCatName;

  Body({
    this.subCatId,
    this.catId,
    this.subCatName,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    subCatId: json["sub_cat_id"],
    catId: json["cat_id"],
    subCatName: json["sub_cat_name"],
  );

  Map<String, dynamic> toJson() => {
    "sub_cat_id": subCatId,
    "cat_id": catId,
    "sub_cat_name": subCatName,
  };
}
