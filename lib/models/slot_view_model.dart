// To parse this JSON data, do
//
//     final viewSlotModel = viewSlotModelFromJson(jsonString);

import 'dart:convert';

ViewSlotModel viewSlotModelFromJson(String str) => ViewSlotModel.fromJson(json.decode(str));

String viewSlotModelToJson(ViewSlotModel data) => json.encode(data.toJson());

class ViewSlotModel {
  bool? status;
  String? msg;
  List<SlotBody>? body;

  ViewSlotModel({
    this.status,
    this.msg,
    this.body,
  });

  factory ViewSlotModel.fromJson(Map<String, dynamic> json) => ViewSlotModel(
    status: json["status"],
    msg: json["msg"],
    body: json["body"] == null ? [] : List<SlotBody>.from(json["body"]!.map((x) => SlotBody.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
  };
}

class SlotBody {
  String? slotId;
  DateTime? date;
  String? fromTime;
  String? toTime;
  String? activeStatus;
  String? bookStatus;

  SlotBody({
    this.slotId,
    this.date,
    this.fromTime,
    this.toTime,
    this.activeStatus,
    this.bookStatus,
  });

  factory SlotBody.fromJson(Map<String, dynamic> json) => SlotBody(
    slotId: json["slot_id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    fromTime: json["from_time"],
    toTime: json["to_time"],
    activeStatus: json["active_status"],
    bookStatus: json["book_status"],
  );

  Map<String, dynamic> toJson() => {
    "slot_id": slotId,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "from_time": fromTime,
    "to_time": toTime,
    "active_status": activeStatus,
    "book_status": bookStatus,
  };
}
