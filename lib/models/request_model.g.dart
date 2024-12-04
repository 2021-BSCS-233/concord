// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestsModel _$RequestsModelFromJson(Map<String, dynamic> json) =>
    RequestsModel(
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      timeStamp: RequestsModel._customDateFromJson(json['timeStamp']),
    );

Map<String, dynamic> _$RequestsModelToJson(RequestsModel instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'timeStamp': RequestsModel._customDateToJson(instance.timeStamp),
    };
