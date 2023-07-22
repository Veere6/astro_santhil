// To parse this JSON data, do
//
//     final customerNameModel = customerNameModelFromJson(jsonString);

import 'dart:convert';

CustomerNameModel customerNameModelFromJson(String str) => CustomerNameModel.fromJson(json.decode(str));

String customerNameModelToJson(CustomerNameModel data) => json.encode(data.toJson());

class CustomerNameModel {
  bool? status;
  String? msg;
  List<Body>? body;

  CustomerNameModel({
    this.status,
    this.msg,
    this.body,
  });

  factory CustomerNameModel.fromJson(Map<String, dynamic> json) => CustomerNameModel(
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
  String? userId;
  String? name;

  Body({
    this.userId,
    this.name,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    userId: json["user_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": [name],
  };
}

