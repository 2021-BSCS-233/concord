// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsModel _$ChatsModelFromJson(Map<String, dynamic> json) => ChatsModel(
      chatType: json['chatType'] as String,
      latestMessage: json['latestMessage'] as String,
      timeStamp: DateTime.parse(json['timeStamp'] as String),
      users: (json['users'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ChatsModelToJson(ChatsModel instance) =>
    <String, dynamic>{
      'chatType': instance.chatType,
      'latestMessage': instance.latestMessage,
      'timeStamp': instance.timeStamp.toIso8601String(),
      'users': instance.users,
    };
