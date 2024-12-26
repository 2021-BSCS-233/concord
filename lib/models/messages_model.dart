import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'messages_model.g.dart';

@JsonSerializable()
class MessagesModel {
  String senderId;
  @JsonKey(fromJson: _customDateFromJson, toJson: _customDateToJson)
  DateTime? timeStamp;
  String message;
  bool edited;
  @JsonKey(defaultValue: [])
  List<String> pinged;
  @JsonKey(defaultValue: [])
  List<String> attachments;
  String? repliedTo;
  @JsonKey(includeToJson: false, includeFromJson: false)
  MessagesModel? repliedMessage;
  @JsonKey(includeToJson: false, includeFromJson: false)
  DocumentReference? docRef;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? id;

  MessagesModel(
      {required this.senderId,
      required this.message,
      required this.edited,
      required this.pinged,
      required this.attachments,
      this.repliedTo,
      this.timeStamp,
      this.repliedMessage,
      this.docRef,
      this.id});

  factory MessagesModel.fromJson(Map<String, dynamic> json) =>
      _$MessagesModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessagesModelToJson(this);

  static DateTime _customDateFromJson(dynamic json) {
    return json.toDate();
  }

  static DateTime _customDateToJson(dynamic timeStamp) {
    return timeStamp;
  }
}

// group owner, multiple admins? or just one the owner
// permission to add, remove members
// delete group
// permission to delete any message? probably not
// max users 10 per group?
