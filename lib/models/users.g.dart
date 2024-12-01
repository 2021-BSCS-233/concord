// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
      username: json['username'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      profilePicture: json['profilePicture'] as String,
      status: json['status'] as String,
      displayStatus: json['displayStatus'] as String,
      pronouns: json['pronouns'] as String,
      aboutMe: json['aboutMe'] as String,
      friends: json['friends'] as List<dynamic>,
    );

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'displayName': instance.displayName,
      'profilePicture': instance.profilePicture,
      'status': instance.status,
      'displayStatus': instance.displayStatus,
      'pronouns': instance.pronouns,
      'aboutMe': instance.aboutMe,
      'friends': instance.friends,
    };
