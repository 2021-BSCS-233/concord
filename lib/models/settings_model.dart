import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_model.g.dart';

@JsonSerializable(createToJson: false)
class SettingsModel {
  @JsonKey(includeToJson: false, includeFromJson: false)
  DocumentReference? docRef;
  String language;
  @JsonKey()
  AccessibilitySettingsModel accessibility;
  @JsonKey()
  NotificationSettingsModel notifications;

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
      accessibility: AccessibilitySettingsModel(
        userColors: true,
        postAtt: true,
      ),
      notifications: NotificationSettingsModel.defaultSettings(),
    );
  }
}

@JsonSerializable()
class AccessibilitySettingsModel {
  bool userColors;
  bool postAtt;

  AccessibilitySettingsModel({
    required this.userColors,
    required this.postAtt,
  });

  factory AccessibilitySettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AccessibilitySettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccessibilitySettingsModelToJson(this);
}

@JsonSerializable(createToJson: false)
class NotificationSettingsModel {
  bool overallNotif;
  bool deviceNotif;
  bool inAppNotif;
  bool inAppNotifPanel;
  bool dmNotif;
  String groupsNotif;
  bool overallPostNotif;
  PostNotificationSettingsModel postNotifications;

  NotificationSettingsModel({
    required this.overallNotif,
    required this.deviceNotif,
    required this.inAppNotif,
    required this.inAppNotifPanel,
    required this.dmNotif,
    required this.groupsNotif,
    required this.overallPostNotif,
    required this.postNotifications,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsModelFromJson(json);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'overallNotif': overallNotif,
      'deviceNotif': deviceNotif,
      'inAppNotif': inAppNotif,
      'inAppNotifPanel': inAppNotifPanel,
      'dmNotif': dmNotif,
      'groupsNotif': groupsNotif,
      'overallPostNotif': overallPostNotif,
      'postNotifications': postNotifications.toJson(),
    };
  }

  factory NotificationSettingsModel.defaultSettings() {
    return NotificationSettingsModel(
      overallNotif: true,
      deviceNotif: true,
      inAppNotif: true,
      inAppNotifPanel: true,
      dmNotif: true,
      groupsNotif: 'All',
      overallPostNotif: true,
      postNotifications: PostNotificationSettingsModel.defaultSettings(),
    );
  }
}

// possible options "All", "MentionOnly", "None"
@JsonSerializable()
class PostNotificationSettingsModel {
  bool friendPostNotif;
  String ownCreatedPosts;
  String followedPosts;

  PostNotificationSettingsModel({
    required this.friendPostNotif,
    required this.ownCreatedPosts,
    required this.followedPosts,
  });

  factory PostNotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$PostNotificationSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostNotificationSettingsModelToJson(this);

  factory PostNotificationSettingsModel.defaultSettings() {
    return PostNotificationSettingsModel(
        friendPostNotif: true, followedPosts: 'All', ownCreatedPosts: 'All');
  }
}
