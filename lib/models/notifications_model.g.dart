// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsModel _$NotificationsModelFromJson(Map<String, dynamic> json) =>
    NotificationsModel(
      sourceType: json['sourceType'] as String,
      fromUser: json['fromUser'] as String,
      toUsers:
          (json['toUsers'] as List<dynamic>).map((e) => e as String).toList(),
      timeStamp: NotificationsModel._customDateFromJson(json['timeStamp']),
      sourceDoc:
          NotificationsModel._docRefFromJson(json['sourceDoc'] as String),
    );

Map<String, dynamic> _$NotificationsModelToJson(NotificationsModel instance) =>
    <String, dynamic>{
      'timeStamp': NotificationsModel._customDateToJson(instance.timeStamp),
      'sourceType': instance.sourceType,
      'sourceDoc': NotificationsModel._docRefToJson(instance.sourceDoc),
      'fromUser': instance.fromUser,
      'toUsers': instance.toUsers,
    };
