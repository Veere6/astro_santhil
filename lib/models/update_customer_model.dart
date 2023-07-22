// To parse this JSON data, do
//
//     final updateCustomerModel = updateCustomerModelFromJson(jsonString);

import 'dart:convert';

UpdateCustomerModel updateCustomerModelFromJson(String str) => UpdateCustomerModel.fromJson(json.decode(str));

String updateCustomerModelToJson(UpdateCustomerModel data) => json.encode(data.toJson());

class UpdateCustomerModel {
  bool? status;
  String? msg;
  List<dynamic>? body;

  UpdateCustomerModel({
    this.status,
    this.msg,
    this.body,
  });

  factory UpdateCustomerModel.fromJson(Map<String, dynamic> json) => UpdateCustomerModel(
    status: json["status"],
    msg: json["msg"],
    body: json["body"] == null ? [] : List<dynamic>.from(json["body"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x)),
  };
}
