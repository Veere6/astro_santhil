// To parse this JSON data, do
//
//     final completeAppointmentModel = completeAppointmentModelFromJson(jsonString);

import 'dart:convert';

CompleteAppointmentModel completeAppointmentModelFromJson(String str) => CompleteAppointmentModel.fromJson(json.decode(str));

String completeAppointmentModelToJson(CompleteAppointmentModel data) => json.encode(data.toJson());

class CompleteAppointmentModel {
  bool? status;
  String? msg;
  List<dynamic>? body;

  CompleteAppointmentModel({
    this.status,
    this.msg,
    this.body,
  });

  factory CompleteAppointmentModel.fromJson(Map<String, dynamic> json) => CompleteAppointmentModel(
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
