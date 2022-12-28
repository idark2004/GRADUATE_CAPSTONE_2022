// To parse this JSON data, do
//
//     final qrModel = qrModelFromJson(jsonString);

// ignore_for_file: must_be_immutable

import 'dart:convert';

Qr qrModelFromJson(String str) => Qr.fromJson(json.decode(str.replaceAll("'", "\"")));

String qrModelToJson(Qr data) => json.encode(data.toJson());

class Qr {
  Qr({
    this.checkin,
    this.plate,
    this.carParkId,
    this.firebaseUrl
  });

  bool? checkin;
  String? plate;
  String? carParkId;
  String? firebaseUrl;

  factory Qr.fromJson(Map<String, dynamic> json) => Qr(
      checkin: json["checkin"],
      plate: json["plate"],
      carParkId: json["carParkId"],
      firebaseUrl: json['firebaseUrl']);

  Map<String, dynamic> toJson() => {
        "checkin": checkin,
        "plate": plate,
        "carParkId": carParkId,
        "firebaseUrl" : firebaseUrl
      };
}
