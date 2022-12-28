// To parse this JSON data, do
//
//     final ticketModel = ticketModelFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

TicketModel ticketModelFromJson(String str) =>
    TicketModel.fromJson(json.decode(str));

String ticketModelToJson(TicketModel data) => json.encode(data.toJson());

class TicketModel extends Equatable {
  const TicketModel({
    required this.tickets,
    required this.totalPage,
  });

  final List<Ticket> tickets;
  final int totalPage;

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        tickets:
            List<Ticket>.from(json["tickets"].map((x) => Ticket.fromJson(x))),
        totalPage: json["totalPage"],
      );

  Map<String, dynamic> toJson() => {
        "tickets": List<dynamic>.from(tickets.map((x) => x.toJson())),
        "totalPage": totalPage,
      };

  @override
  List<Object?> get props => [tickets, totalPage];
}

class Ticket {
  Ticket({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.reservationFee,
    required this.overdueFee,
    required this.bookTime,
    required this.arriveTime,
    required this.totalFee,
    required this.picInUrl,
    required this.picOutUrl,
    required this.carParkId,
    required this.plateNumber,
    required this.phoneNumber,
    required this.fullName,
    required this.status,
    required this.carPark,
  });

  final String id;
  final dynamic startTime;
  final dynamic endTime;
  final int reservationFee;
  final int overdueFee;
  final dynamic bookTime;
  final dynamic arriveTime;
  final int totalFee;
  final String picInUrl;
  final String picOutUrl;
  final String carParkId;
  final String plateNumber;
  final String phoneNumber;
  final String fullName;
  final int status;
  final CarPark carPark;

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json["id"],
        startTime:
            json["startTime"] != null ? DateTime.parse(json["startTime"]) : "",
        endTime: json["endTime"] != null ? DateTime.parse(json["endTime"]) : "",
        reservationFee: double.parse(json["reservationFee"].toString()).toInt(),
        overdueFee: double.parse(json["overdueFee"].toString()).toInt(),
        bookTime:
            json["bookTime"] != null ? DateTime.parse(json["bookTime"]) : "",
        arriveTime: json["arriveTime"] != null
            ? DateTime.parse(json["arriveTime"])
            : "",
        totalFee: double.parse(json["totalFee"].toString()).toInt(),
        picInUrl: json["picInUrl"] ?? "",
        picOutUrl: json["picOutUrl"] ?? "",
        carParkId: json["carParkId"],
        plateNumber: json["plateNumber"],
        phoneNumber: json["phoneNumber"],
        fullName: json["fullName"],
        status: json["status"],
        carPark: CarPark.fromJson(json["carPark"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startTime": startTime?.toIso8601String(),
        "endTime": endTime?.toIso8601String(),
        "reservationFee": reservationFee,
        "bookTime": bookTime,
        "arriveTime": arriveTime,
        "totalFee": totalFee,
        "picInUrl": picInUrl,
        "picOutUrl": picOutUrl,
        "carParkId": carParkId,
        "plateNumber": plateNumber,
        "phoneNumber": phoneNumber,
        "fullName": fullName,
        "status": status,
        "carPark": carPark.toJson(),
      };
}

class TicketPreview {
  TicketPreview(
      {required this.reservationFee,
      required this.arriveTime,
      required this.carParkName,
      required this.carParkAddress,
      required this.plateNumber,
      required this.phoneNumber,
      required this.priceTable,
      required this.reservationFeePercentage,
      required this.feePerHour});

  final double reservationFee;
  final dynamic arriveTime;
  final String plateNumber;
  final String phoneNumber;
  final String carParkName;
  final String carParkAddress;
  final List<dynamic> priceTable;
  final String? feePerHour;
  final String reservationFeePercentage;

  factory TicketPreview.fromJson(Map<String, dynamic> json) => TicketPreview(
      reservationFee: json["reservationFee"] + .0,
      plateNumber: json["plateNumber"],
      phoneNumber: json["phoneNumber"],
      arriveTime: DateFormat("dd-MM-yyyy HH:mm")
          .format(DateTime.parse(json["arriveTime"])),
      carParkAddress: json["carParkAddress"],
      carParkName: json["carParkName"],
      feePerHour: json["feePerHour"]?.toString(),
      reservationFeePercentage: json["reservationFeePercentage"].toString(),
      priceTable: json["priceTable"]);

  Map<String, dynamic> toJson() => {
        "reservationFee": reservationFee,
        "plateNumber": plateNumber,
        "phoneNumber": phoneNumber,
        "arriveTime": arriveTime,
        "carParkAdress": carParkAddress,
        "carParkName": carParkName,
        "priceTable": priceTable,
        "feePerHour": feePerHour,
        "reservationFeePercentage": reservationFeePercentage
      };
}

class CarPark {
  CarPark({
    required this.name,
    required this.street,
    required this.addressNumber,
    required this.ward,
    required this.district,
    required this.city,
  });

  final String name;
  final String street;
  final String addressNumber;
  final String ward;
  final String district;
  final String city;

  factory CarPark.fromJson(Map<String, dynamic> json) => CarPark(
        name: json["name"],
        street: json["street"],
        addressNumber: json["addressNumber"],
        ward: json["ward"],
        district: json["district"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "street": street,
        "addressNumber": addressNumber,
        "ward": ward,
        "district": district,
        "city": city,
      };
}
