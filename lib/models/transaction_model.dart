import 'package:flutter/material.dart';

class TransactionModel {
  final int id;
  final UserModel user;
  final String type;
  final String amount;
  final String balanceBefore;
  final String balanceAfter;
  final String reference;
  final String? description;

  TransactionModel({
    required this.id,
    required this.user,
    required this.type,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.reference,
    this.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
        user: UserModel.fromJson(json["user"]),
        type: json["type"],
        amount: json["amount"].toString(),
        balanceBefore: json["balance_before"].toString(),
        balanceAfter: json["balance_after"].toString(),
        reference: json["reference"],
        description: json["description"],
      );

  String get displayAmount => "$amount LYD";
  String get userName => user.name;
  bool get isCredit => type == "credit";
  Color get typeColor => isCredit ? Colors.green : Colors.red;
}

class UserModel {
  final int id;
  final String name;

  UserModel({required this.id, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(id: json["id"], name: json["name"] ?? "Unknown");
}
