// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel(
      language: json['language'] as String,
      accessibility: AccessibilitySettings.fromJson(
          json['accessibility'] as Map<String, dynamic>),
      notifications: NotificationSettings.fromJson(
          json['notifications'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'language': instance.language,
      'accessibility': instance.accessibility,
      'notifications': instance.notifications,
    };

AccessibilitySettings _$AccessibilitySettingsFromJson(
        Map<String, dynamic> json) =>
    AccessibilitySettings(
      toggleUserColors: json['toggleUserColors'] as bool,
      disablePostAttachments: json['disablePostAttachments'] as bool,
    );

Map<String, dynamic> _$AccessibilitySettingsToJson(
        AccessibilitySettings instance) =>
    <String, dynamic>{
      'toggleUserColors': instance.toggleUserColors,
      'disablePostAttachments': instance.disablePostAttachments,
    };

NotificationSettings _$NotificationSettingsFromJson(
        Map<String, dynamic> json) =>
    NotificationSettings(
      overallOff: json['overallOff'] as bool,
      deviceNotif: json['deviceNotif'] as bool,
      inAppNotif: json['inAppNotif'] as bool,
      inAppNotifPanel: json['inAppNotifPanel'] as bool,
      chatNotifications: ChatNotificationSettings.fromJson(
          json['chatNotifications'] as Map<String, dynamic>),
      postNotifications: PostNotificationSettings.fromJson(
          json['postNotifications'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationSettingsToJson(
        NotificationSettings instance) =>
    <String, dynamic>{
      'overallOff': instance.overallOff,
      'deviceNotif': instance.deviceNotif,
      'inAppNotif': instance.inAppNotif,
      'inAppNotifPanel': instance.inAppNotifPanel,
      'chatNotifications': instance.chatNotifications,
      'postNotifications': instance.postNotifications,
    };

ChatNotificationSettings _$ChatNotificationSettingsFromJson(
        Map<String, dynamic> json) =>
    ChatNotificationSettings(
      dms: json['dms'] as String,
      groups: json['groups'] as String,
    );

Map<String, dynamic> _$ChatNotificationSettingsToJson(
        ChatNotificationSettings instance) =>
    <String, dynamic>{
      'dms': instance.dms,
      'groups': instance.groups,
    };

PostNotificationSettings _$PostNotificationSettingsFromJson(
        Map<String, dynamic> json) =>
    PostNotificationSettings(
      overallToggleForFollowing: json['overallToggleForFollowing'] as bool,
      friendCreatePost: json['friendCreatePost'] as bool,
      ownCreatedPosts: json['ownCreatedPosts'] as String,
      followedPosts: json['followedPosts'] as String,
    );

Map<String, dynamic> _$PostNotificationSettingsToJson(
        PostNotificationSettings instance) =>
    <String, dynamic>{
      'friendCreatePost': instance.friendCreatePost,
      'overallToggleForFollowing': instance.overallToggleForFollowing,
      'ownCreatedPosts': instance.ownCreatedPosts,
      'followedPosts': instance.followedPosts,
    };
