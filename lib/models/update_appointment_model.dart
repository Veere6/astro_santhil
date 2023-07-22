// To parse this JSON data, do
//
//     final updateAppointmentModel = updateAppointmentModelFromJson(jsonString);

import 'dart:convert';

UpdateAppointmentModel updateAppointmentModelFromJson(String str) => UpdateAppointmentModel.fromJson(json.decode(str));

String updateAppointmentModelToJson(UpdateAppointmentModel data) => json.encode(data.toJson());

class UpdateAppointmentModel {
  bool? status;
  String? msg;
  List<dynamic>? body;

  UpdateAppointmentModel({
    this.status,
    this.msg,
    this.body,
  });

  factory UpdateAppointmentModel.fromJson(Map<String, dynamic> json) => UpdateAppointmentModel(
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
