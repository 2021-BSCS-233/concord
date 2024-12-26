// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagesModel _$MessagesModelFromJson(Map<String, dynamic> json) =>
    MessagesModel(
      senderId: json['senderId'] as String,
      message: json['message'] as String,
      edited: json['edited'] as bool,
      pinged: (json['pinged'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      repliedTo: json['repliedTo'] as String?,
      timeStamp: MessagesModel._customDateFromJson(json['timeStamp']),
    );

Map<String, dynamic> _$MessagesModelToJson(MessagesModel instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'timeStamp': MessagesModel._customDateToJson(instance.timeStamp),
      'message': instance.message,
      'edited': instance.edited,
      'pinged': instance.pinged,
      'attachments': instance.attachments,
      'repliedTo': instance.repliedTo,
    };
