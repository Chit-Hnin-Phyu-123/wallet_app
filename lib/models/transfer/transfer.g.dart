// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transfer _$TransferFromJson(Map<String, dynamic> json) => Transfer(
      amount: json['Amount'] as int,
      timestamp: json['Timestamp'] as String,
      userId: json['UserId'] as String,
      userName: json['UserName'] as String,
      userEmail: json['UserEmail'] as String,
    );

Map<String, dynamic> _$TransferToJson(Transfer instance) => <String, dynamic>{
      'Amount': instance.amount,
      'Timestamp': instance.timestamp,
      'UserId': instance.userId,
      'UserName': instance.userName,
      'UserEmail': instance.userEmail,
    };
