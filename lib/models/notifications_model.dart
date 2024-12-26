import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concord/models/posts_model.dart';
import 'package:concord/models/users_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notifications_model.g.dart';

@JsonSerializable()
class NotificationsModel {
  @JsonKey(fromJson: _customDateFromJson, toJson: _customDateToJson)
  DateTime timeStamp;
  String sourceType;
  @JsonKey(fromJson: _docRefFromJson, toJson: _docRefToJson)
  DocumentReference? sourceDoc; //for redirecting, only for posts
  String fromUser;
  List<String> toUsers;
  @JsonKey(includeToJson: false, includeFromJson: false)
  PostsModel? sourcePostData;
  @JsonKey(includeToJson: false, includeFromJson: false)
  UsersModel? fromUserData;
  @JsonKey(includeToJson: false, includeFromJson: false)
  DocumentReference? docRef;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? id;

  NotificationsModel(
      {required this.sourceType,
      required this.fromUser,
      required this.toUsers,
      required this.timeStamp,
      this.sourceDoc,
      this.sourcePostData,
      this.fromUserData,
      this.docRef,
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

  static DocumentReference? _docRefFromJson(String json) {
    if(json != '') {
      return FirebaseFirestore.instance.doc(json);
    }
    else {
      return null;
    }
  }

  static String _docRefToJson(DocumentReference? reference) {
    return reference?.path ?? '';
  }
}

//possible notifications
//posts, '(user) commented(maybe comment) on your post(name)'
//posts, '(user) commented on your comment(maybe comment) in post(name)'
//posts, 'your comment(maybe comment) was (action: deleted,praised,not-helpful)'
//pings, always
//request, 'friend request from (user)'
