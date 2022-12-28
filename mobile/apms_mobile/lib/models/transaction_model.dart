// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) => TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) => json.encode(data.toJson());

class TransactionModel {
    TransactionModel({
        required this.transactions,
        required this.totalPage,
    });

    final List<Transaction> transactions;
    final int totalPage;

    factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        transactions: List<Transaction>.from(json["transactions"].map((x) => Transaction.fromJson(x))),
        totalPage: json["totalPage"],
    );

    Map<String, dynamic> toJson() => {
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
        "totalPage": totalPage,
    };
}

class Transaction {
    Transaction({
        required this.id,
        required this.amount,
        required this.time,
        required this.transactionType,
    });

    final String id;
    final int amount;
    final DateTime time;
    final int transactionType;

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        amount: double.parse(json["amount"].toString()).toInt(),
        time: DateTime.parse(json["time"]),
        transactionType: json["transactionType"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "time": time.toIso8601String(),
        "transactionType": transactionType,
    };
}
