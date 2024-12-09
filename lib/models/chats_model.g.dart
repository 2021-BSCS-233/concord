// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsModel _$ChatsModelFromJson(Map<String, dynamic> json) => ChatsModel(
      chatType: json['chatType'] as String,
      latestMessage: json['latestMessage'] as String,
      timeStamp: ChatsModel._customDateFromJson(json['timeStamp']),
      users: (json['users'] as List<dynamic>).map((e) => e as String).toList(),
    )..chatGroupName = json['chatGroupName'] as String? ?? '';

Map<String, dynamic> _$ChatsModelToJson(ChatsModel instance) =>
    <String, dynamic>{
      'chatType': instance.chatType,
      'chatGroupName': instance.chatGroupName,
      'latestMessage': instance.latestMessage,
      'timeStamp': ChatsModel._customDateToJson(instance.timeStamp),
      'users': instance.users,
    };
