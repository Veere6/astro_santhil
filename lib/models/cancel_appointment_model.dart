// To parse this JSON data, do
//
//     final cancelAppointmentModel = cancelAppointmentModelFromJson(jsonString);

import 'dart:convert';

CancelAppointmentModel cancelAppointmentModelFromJson(String str) => CancelAppointmentModel.fromJson(json.decode(str));

String cancelAppointmentModelToJson(CancelAppointmentModel data) => json.encode(data.toJson());

class CancelAppointmentModel {
  bool? status;
  String? msg;
  List<dynamic>? body;

  CancelAppointmentModel({
    this.status,
    this.msg,
    this.body,
  });

  factory CancelAppointmentModel.fromJson(Map<String, dynamic> json) => CancelAppointmentModel(
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
