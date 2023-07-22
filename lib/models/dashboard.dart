// To parse this JSON data, do
//
//     final dashboard = dashboardFromJson(jsonString);

import 'dart:convert';

Dashboard dashboardFromJson(String str) => Dashboard.fromJson(json.decode(str));

String dashboardToJson(Dashboard data) => json.encode(data.toJson());

class Dashboard {
  bool? status;
  String? msg;
  List<Body>? body;

  Dashboard({
    this.status,
    this.msg,
    this.body,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
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
  int? appointmentCounts;
  String? totalAmount;

  Body({
    this.appointmentCounts,
    this.totalAmount,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    appointmentCounts: json["appointment_counts"],
    totalAmount: json["total_amount"],
  );

  Map<String, dynamic> toJson() => {
    "appointment_counts": appointmentCounts,
    "total_amount": totalAmount,
  };
}
