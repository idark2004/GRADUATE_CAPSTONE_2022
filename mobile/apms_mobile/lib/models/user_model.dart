// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
        required this.id,
        required this.phoneNumber,
        required this.fullName,
        required this.accountBalance,
    });

    final String id;
    final String phoneNumber;
    final String fullName;
    final int accountBalance;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        phoneNumber: json["phoneNumber"],
        fullName: json["fullName"],
        accountBalance: json["accountBalance"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "phoneNumber": phoneNumber,
        "fullName": fullName,
        "accountBalance": accountBalance,
    };
}
