// To parse this JSON data, do
//
//     final addCustomerModel = addCustomerModelFromJson(jsonString);

import 'dart:convert';

AddCustomerModel addCustomerModelFromJson(String str) => AddCustomerModel.fromJson(json.decode(str));

String addCustomerModelToJson(AddCustomerModel data) => json.encode(data.toJson());

class AddCustomerModel {
  bool? status;
  String? msg;

  AddCustomerModel({
    this.status,
    this.msg,
  });

  factory AddCustomerModel.fromJson(Map<String, dynamic> json) => AddCustomerModel(
    status: json["status"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
  };
}
