import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transfer.g.dart';

@JsonSerializable()
class Transfer {
  final int amount;
  final String timestamp;
  final String userId;
  final String userName;
  final String userEmail;
  const Transfer({
    required this.amount,
    required this.timestamp,
    required this.userId,
    required this.userName,
    required this.userEmail,
  });
  factory Transfer.fromJson(Map<String, dynamic> json) =>
      _$TransferFromJson(json);
  Map<String, dynamic> toJson() => _$TransferToJson(this);
}
