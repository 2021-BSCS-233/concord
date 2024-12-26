import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concord/models/users_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chats_model.g.dart';

@JsonSerializable()
class ChatsModel {
  String chatType;
  String chatGroupName;
  String groupOwner;
  List<String> users;
  List<String> visible;
  List<String> noNotifications;
  List<String> onlyMentions;
  String latestMessage;
  @JsonKey(fromJson: _customDateFromJson, toJson: _customDateToJson)
  DateTime timeStamp;
  @JsonKey(includeToJson: false, includeFromJson: false)
  List<UsersModel>? receiverData;
  @JsonKey(includeToJson: false, includeFromJson: false)
  DocumentReference? docRef;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? id;

  ChatsModel(
      {required this.chatType,
      required this.latestMessage,
      required this.timeStamp,
      required this.users,
      required this.visible,
      required this.noNotifications,
      required this.onlyMentions,
      required this.groupOwner,
      required this.chatGroupName,
      this.receiverData,
      this.docRef,
      this.id});

  factory ChatsModel.fromJson(Map<String, dynamic> json) =>
      _$ChatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatsModelToJson(this);

  static DateTime _customDateFromJson(dynamic json) {
    return json.toDate();
  }

  static DateTime _customDateToJson(dynamic timeStamp) {
    return timeStamp;
  }
}
