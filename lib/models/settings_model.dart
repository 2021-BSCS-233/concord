import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_model.g.dart';

@JsonSerializable()
class SettingsModel {
  @JsonKey(includeToJson: false, includeFromJson: false)
  DocumentReference? docRef;
  String language;
  @JsonKey()
  AccessibilitySettings accessibility;
  @JsonKey()
  NotificationSettings notifications;

  SettingsModel({
    this.docRef,
    required this.language,
    required this.accessibility,
    required this.notifications,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'language': language,
      'accessibility': accessibility.toJson(),
      'notifications': notifications.toJson(),
    };
  }

  factory SettingsModel.defaultSettings() {
    return SettingsModel(
      language: 'en', // Default language
      accessibility: AccessibilitySettings(
        userColors: true,
        postAtt: true,
      ),
      notifications: NotificationSettings.defaultSettings(),
    );
  }
}

@JsonSerializable()
class AccessibilitySettings {
  bool userColors;
  bool postAtt;

  AccessibilitySettings({
    required this.userColors,
    required this.postAtt,
  });

  factory AccessibilitySettings.fromJson(Map<String, dynamic> json) =>
      _$AccessibilitySettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AccessibilitySettingsToJson(this);
}

@JsonSerializable()
class NotificationSettings {
  bool overallOff;
  bool deviceNotif;
  bool inAppNotif;
  bool inAppNotifPanel;
  ChatNotificationSettings chatNotifications;
  PostNotificationSettings postNotifications;

  NotificationSettings({
    required this.overallOff,
    required this.deviceNotif,
    required this.inAppNotif,
    required this.inAppNotifPanel,
    required this.chatNotifications,
    required this.postNotifications,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'overallOff': overallOff,
      'deviceNotif': deviceNotif,
      'inAppNotif': inAppNotif,
      'inAppNotifPanel': inAppNotifPanel,
      'chatNotifications': chatNotifications.toJson(),
      'postNotifications': postNotifications.toJson(),
    };
  }

  factory NotificationSettings.defaultSettings() {
    return NotificationSettings(
      overallOff: false,
      deviceNotif: true,
      inAppNotif: true,
      inAppNotifPanel: true,
      chatNotifications: ChatNotificationSettings.defaultSettings(),
      postNotifications: PostNotificationSettings.defaultSettings(),
    );
  }
}

// possible options "All", "MentionOnly", "None"
@JsonSerializable()
class ChatNotificationSettings {
  String dms;
  String groups;

  ChatNotificationSettings({
    required this.dms,
    required this.groups,
  });

  factory ChatNotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$ChatNotificationSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ChatNotificationSettingsToJson(this);

  factory ChatNotificationSettings.defaultSettings() {
    return ChatNotificationSettings(dms: 'All', groups: 'All');
  }
}

@JsonSerializable()
class PostNotificationSettings {
  bool friendCreatePost;
  bool overallToggleForFollowing;
  String ownCreatedPosts;
  String followedPosts;

  PostNotificationSettings({
    required this.overallToggleForFollowing,
    required this.friendCreatePost,
    required this.ownCreatedPosts,
    required this.followedPosts,
  });

  factory PostNotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$PostNotificationSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$PostNotificationSettingsToJson(this);

  factory PostNotificationSettings.defaultSettings() {
    return PostNotificationSettings(
        overallToggleForFollowing: true,
        friendCreatePost: true,
        followedPosts: 'All',
        ownCreatedPosts: 'All');
  }
}
