// To parse this JSON data, do
//
//     final addAppointmentModel = addAppointmentModelFromJson(jsonString);

import 'dart:convert';

AddAppointmentModel addAppointmentModelFromJson(String str) => AddAppointmentModel.fromJson(json.decode(str));

String addAppointmentModelToJson(AddAppointmentModel data) => json.encode(data.toJson());

class AddAppointmentModel {
  bool? status;
  String? msg;
  List<dynamic>? body;

  AddAppointmentModel({
    this.status,
    this.msg,
    this.body,
  });

  factory AddAppointmentModel.fromJson(Map<String, dynamic> json) => AddAppointmentModel(
    status: json["status"],
    msg: json["msg"],
    body: List<dynamic>.from(json["body"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "body": List<dynamic>.from(body!.map((x) => x)),
  };
}
