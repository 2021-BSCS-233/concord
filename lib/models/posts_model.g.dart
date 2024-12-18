// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostsModel _$PostsModelFromJson(Map<String, dynamic> json) => PostsModel(
      poster: json['poster'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      followers:
          (json['followers'] as List<dynamic>).map((e) => e as String).toList(),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      timeStamp: PostsModel._customDateFromJson(json['timeStamp']),
    );

Map<String, dynamic> _$PostsModelToJson(PostsModel instance) =>
    <String, dynamic>{
      'poster': instance.poster,
      'title': instance.title,
      'description': instance.description,
      'attachments': instance.attachments,
      'categories': instance.categories,
      'followers': instance.followers,
      'participants': instance.participants,
      'timeStamp': PostsModel._customDateToJson(instance.timeStamp),
    };
