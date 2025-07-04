// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersModel _$UsersModelFromJson(Map<String, dynamic> json) => UsersModel(
      username: json['username'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      profilePicture: json['profilePicture'] as String,
      statusText: json['statusText'] as String,
      idle: json['idle'] as bool,
      bannerImg: json['bannerImg'] as String,
      bannerColor: (json['bannerColor'] as num).toInt(),
      status: json['status'] as String,
      displayStatus: json['displayStatus'] as String,
      pronouns: json['pronouns'] as String,
      aboutMe: json['aboutMe'] as String,
      friends:
          (json['friends'] as List<dynamic>).map((e) => e as String).toList(),
      followingPosts: (json['followingPosts'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UsersModelToJson(UsersModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'displayName': instance.displayName,
      'profilePicture': instance.profilePicture,
      'statusText': instance.statusText,
      'idle': instance.idle,
      'bannerImg': instance.bannerImg,
      'bannerColor': instance.bannerColor,
      'status': instance.status,
      'displayStatus': instance.displayStatus,
      'pronouns': instance.pronouns,
      'aboutMe': instance.aboutMe,
      'friends': instance.friends,
      'followingPosts': instance.followingPosts,
    };
