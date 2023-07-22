// To parse this JSON data, do
//
//     final appointmentViewModel = appointmentViewModelFromJson(jsonString);

import 'dart:convert';

AppointmentViewModel appointmentViewModelFromJson(String str) => AppointmentViewModel.fromJson(json.decode(str));

String appointmentViewModelToJson(AppointmentViewModel data) => json.encode(data.toJson());

class AppointmentViewModel {
  bool? status;
  String? msg;
  List<Body>? body;

  AppointmentViewModel({
    this.status,
    this.msg,
    this.body,
  });

  factory AppointmentViewModel.fromJson(Map<String, dynamic> json) => AppointmentViewModel(
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
    date: DateTime.parse(json["date"]),
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
    "date": "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
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
