// To parse this JSON data, do
//
//     final appointmentDetailModel = appointmentDetailModelFromJson(jsonString);

import 'dart:convert';

AppointmentDetailModel appointmentDetailModelFromJson(String str) => AppointmentDetailModel.fromJson(json.decode(str));

String appointmentDetailModelToJson(AppointmentDetailModel data) => json.encode(data.toJson());

class AppointmentDetailModel {
  bool? status;
  String? msg;
  List<Body>? body;

  AppointmentDetailModel({
    this.status,
    this.msg,
    this.body,
  });

  factory AppointmentDetailModel.fromJson(Map<String, dynamic> json) => AppointmentDetailModel(
    status: json["status"],
    msg: json["msg"],
    body: json["body"] == null ? [] : List<Body>.from(json["body"]!.map((x) => Body.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
  };
}

class Body {
  String? id;
  String? customerId;
  DateTime? date;
  String? time;
  String? status;
  String? message;
  String? fees;
  String? feesStatus;
  String? cancelStatus;
  String? name;
  String? phone;

  Body({
    this.id,
    this.customerId,
    this.date,
    this.time,
    this.status,
    this.message,
    this.fees,
    this.feesStatus,
    this.cancelStatus,
    this.name,
    this.phone,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    id: json["id"],
    customerId: json["customer_id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
    status: json["status"],
    message: json["message"],
    fees: json["fees"],
    feesStatus: json["fees_status"],
    cancelStatus: json["cancel_status"],
    name: json["name"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_id": customerId,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "time": time,
    "status": status,
    "message": message,
    "fees": fees,
    "fees_status": feesStatus,
    "cancel_status": cancelStatus,
    "name": name,
    "phone": phone,
  };
}
