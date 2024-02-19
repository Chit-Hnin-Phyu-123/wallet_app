// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
      id: json['id'] as String,
      name: json['Name'] as String,
      email: json['Email'] as String,
      photoUrl: json['PhotoUrl'] as String,
      token: json['DeviceToken'] as String,
    );

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'id': instance.id,
      'Name': instance.name,
      'Email': instance.email,
      'PhotoUrl': instance.photoUrl,
      'DeviceToken': instance.token,
    };
