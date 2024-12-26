// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestsModel _$RequestsModelFromJson(Map<String, dynamic> json) =>
    RequestsModel(
      senderId: json['senderId'] as String,
      senderDocRef:
          RequestsModel._docRefFromJson(json['senderDocRef'] as String),
      receiverId: json['receiverId'] as String,
      receiverDocRef:
          RequestsModel._docRefFromJson(json['receiverDocRef'] as String),
      timeStamp: RequestsModel._customDateFromJson(json['timeStamp']),
    );

Map<String, dynamic> _$RequestsModelToJson(RequestsModel instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'senderDocRef': RequestsModel._docRefToJson(instance.senderDocRef),
      'receiverDocRef': RequestsModel._docRefToJson(instance.receiverDocRef),
      'timeStamp': RequestsModel._customDateToJson(instance.timeStamp),
    };
