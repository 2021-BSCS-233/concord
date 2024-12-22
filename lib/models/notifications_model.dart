import 'package:json_annotation/json_annotation.dart';

part 'notifications_model.g.dart';

@JsonSerializable()
class NotificationsModel {
  @JsonKey(fromJson: _customDateFromJson, toJson: _customDateToJson)
  DateTime? timeStamp;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? id;
  String sourceCollection; //defines display
  String sourceDoc; //for redirecting
  String title;
  String fromUser;
  List<String> toUsers; //one doc for multiple users

  NotificationsModel(
      {required this.sourceCollection,
      required this.sourceDoc,
      required this.title,
      required this.fromUser,
      required this.toUsers,
      this.timeStamp,
      this.id});

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsModelToJson(this);

  static DateTime _customDateFromJson(dynamic json) {
    return json.toDate();
  }

  static DateTime _customDateToJson(dynamic timeStamp) {
    return timeStamp;
  }
}

//possible notifications
//posts, '(user) commented(maybe comment) on your post(name)'
//posts, '(user) commented on your comment(maybe comment) in post(name)'
//posts, 'your comment(maybe comment) was (action: deleted,praised,not-helpful)'
//pings, always
//request, 'friend request from (user)'
