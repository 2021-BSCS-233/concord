// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel(
      language: json['language'] as String,
      postPreference: (json['postPreference'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      accessibility: AccessibilitySettingsModel.fromJson(
          json['accessibility'] as Map<String, dynamic>),
      notifications: NotificationSettingsModel.fromJson(
          json['notifications'] as Map<String, dynamic>),
    );

AccessibilitySettingsModel _$AccessibilitySettingsModelFromJson(
        Map<String, dynamic> json) =>
    AccessibilitySettingsModel(
      userColors: json['userColors'] as bool,
      postAtt: json['postAtt'] as bool,
    );

Map<String, dynamic> _$AccessibilitySettingsModelToJson(
        AccessibilitySettingsModel instance) =>
    <String, dynamic>{
      'userColors': instance.userColors,
      'postAtt': instance.postAtt,
    };

NotificationSettingsModel _$NotificationSettingsModelFromJson(
        Map<String, dynamic> json) =>
    NotificationSettingsModel(
      overallNotif: json['overallNotif'] as bool,
      deviceNotif: json['deviceNotif'] as bool,
      inAppNotif: json['inAppNotif'] as bool,
      inAppNotifPanel: json['inAppNotifPanel'] as bool,
      dmNotif: json['dmNotif'] as bool,
      groupsNotif: json['groupsNotif'] as String,
      overallPostNotif: json['overallPostNotif'] as bool,
      postNotifications: PostNotificationSettingsModel.fromJson(
          json['postNotifications'] as Map<String, dynamic>),
    );

PostNotificationSettingsModel _$PostNotificationSettingsModelFromJson(
        Map<String, dynamic> json) =>
    PostNotificationSettingsModel(
      friendPostNotif: json['friendPostNotif'] as bool,
      ownCreatedPosts: json['ownCreatedPosts'] as String,
      followedPosts: json['followedPosts'] as String,
    );

Map<String, dynamic> _$PostNotificationSettingsModelToJson(
        PostNotificationSettingsModel instance) =>
    <String, dynamic>{
      'friendPostNotif': instance.friendPostNotif,
      'ownCreatedPosts': instance.ownCreatedPosts,
      'followedPosts': instance.followedPosts,
    };
