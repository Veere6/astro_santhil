// To parse this JSON data, do
//
//     final viewCustomerModel = viewCustomerModelFromJson(jsonString);

import 'dart:convert';

ViewCustomerModel viewCustomerModelFromJson(String str) => ViewCustomerModel.fromJson(json.decode(str));

String viewCustomerModelToJson(ViewCustomerModel data) => json.encode(data.toJson());

class ViewCustomerModel {
  bool? status;
  String? msg;
  List<Datum>? data;

  ViewCustomerModel({
    this.status,
    this.msg,
    this.data,
  });

  factory ViewCustomerModel.fromJson(Map<String, dynamic> json) => ViewCustomerModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? userId;
  String? name;
  String? gender;
  String? place;
  String? city;
  DateTime? dob;
  String? birthTime;
  String? birthPlace;
  String? email;
  String? phone;
  String? catId;
  String? subCatId;
  String? hImage;
  String? uImage;
  String? text;

  Datum({
    this.userId,
    this.name,
    this.gender,
    this.place,
    this.city,
    this.dob,
    this.birthTime,
    this.birthPlace,
    this.email,
    this.phone,
    this.catId,
    this.subCatId,
    this.hImage,
    this.uImage,
    this.text,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    userId: json["user_id"],
    name: json["name"],
    gender: json["gender"],
    place: json["place"],
    city: json["city"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    birthTime: json["birth_time"],
    birthPlace: json["birth_place"],
    email: json["email"],
    phone: json["phone"],
    catId: json["cat_id"],
    subCatId: json["sub_cat_id"],
    hImage: json["h_image"],
    uImage: json["u_image"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "gender": gender,
    "place": place,
    "city": city,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "birth_time": birthTime,
    "birth_place": birthPlace,
    "email": email,
    "phone": phone,
    "cat_id": catId,
    "sub_cat_id": subCatId,
    "h_image": hImage,
    "u_image": uImage,
    "text": text,
  };
}
