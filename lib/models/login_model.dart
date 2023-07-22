// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool? status;
  String? msg;
  List<Body>? body;

  LoginModel({
    this.status,
    this.msg,
    this.body,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
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
  String? adminName;
  String? adminEmail;
  String? id;

  Body({
    this.adminName,
    this.adminEmail,
    this.id,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    adminName: json["admin_name"],
    adminEmail: json["admin_email"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "admin_name": adminName,
    "admin_email": adminEmail,
    "id": id,
  };
}
