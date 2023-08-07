// To parse this JSON data, do
//
//     final upcomingAppointmentModel = upcomingAppointmentModelFromJson(jsonString);

import 'dart:convert';

UpcomingAppointmentModel upcomingAppointmentModelFromJson(String str) => UpcomingAppointmentModel.fromJson(json.decode(str));

String upcomingAppointmentModelToJson(UpcomingAppointmentModel data) => json.encode(data.toJson());

class UpcomingAppointmentModel {
  bool? status;
  String? msg;
  List<uBody>? body;

  UpcomingAppointmentModel({
    this.status,
    this.msg,
    this.body,
  });

  factory UpcomingAppointmentModel.fromJson(Map<String, dynamic> json) => UpcomingAppointmentModel(
    status: json["status"],
    msg: json["msg"],
    body: json["body"] == null ? [] : List<uBody>.from(json["body"]!.map((x) => uBody.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
  };
}

class uBody {
  String? id;
  String? customerId;
  DateTime? date;
  String? slotId;
  String? from_time;
  String? to_time;
  String? status;
  String? message;
  String? fees;
  String? feesStatus;
  String? cancelStatus;
  String? name;
  String? phone;

  uBody({
    this.id,
    this.customerId,
    this.date,
    this.slotId,
    this.from_time,
    this.to_time,
    this.status,
    this.message,
    this.fees,
    this.feesStatus,
    this.cancelStatus,
    this.name,
    this.phone,
  });

  factory uBody.fromJson(Map<String, dynamic> json) => uBody(
    id: json["id"],
    customerId: json["customer_id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    slotId: json["slot_id"],
    from_time: json["from_time"],
    to_time: json["to_time"],
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
    "slot_id": slotId,
    "from_time": from_time,
    "to_time": to_time,
    "status": status,
    "message": message,
    "fees": fees,
    "fees_status": feesStatus,
    "cancel_status": cancelStatus,
    "name": name,
    "phone": phone,
  };
}
