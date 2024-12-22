// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsModel _$NotificationsModelFromJson(Map<String, dynamic> json) =>
    NotificationsModel(
      sourceCollection: json['sourceCollection'] as String,
      sourceDoc: json['sourceDoc'] as String,
      title: json['title'] as String,
      fromUser: json['fromUser'] as String,
      toUsers:
          (json['toUsers'] as List<dynamic>).map((e) => e as String).toList(),
      timeStamp: NotificationsModel._customDateFromJson(json['timeStamp']),
    );

Map<String, dynamic> _$NotificationsModelToJson(NotificationsModel instance) =>
    <String, dynamic>{
      'timeStamp': NotificationsModel._customDateToJson(instance.timeStamp),
      'sourceCollection': instance.sourceCollection,
      'sourceDoc': instance.sourceDoc,
      'title': instance.title,
      'fromUser': instance.fromUser,
      'toUsers': instance.toUsers,
    };
