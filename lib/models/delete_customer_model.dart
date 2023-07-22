// To parse this JSON data, do
//
//     final deleteCustomerModel = deleteCustomerModelFromJson(jsonString);

import 'dart:convert';

DeleteCustomerModel deleteCustomerModelFromJson(String str) => DeleteCustomerModel.fromJson(json.decode(str));

String deleteCustomerModelToJson(DeleteCustomerModel data) => json.encode(data.toJson());

class DeleteCustomerModel {
  bool? status;
  String? msg;

  DeleteCustomerModel({
    this.status,
    this.msg,
  });

  factory DeleteCustomerModel.fromJson(Map<String, dynamic> json) => DeleteCustomerModel(
    status: json["status"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
  };
}
