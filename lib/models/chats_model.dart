import 'package:concord/models/users_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chats_model.g.dart';

@JsonSerializable()
class ChatsModel {
  String chatType;
  String latestMessage;
  DateTime timeStamp;
  List<String> users;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? id;
  @JsonKey(includeToJson: false, includeFromJson: false)
  List<UsersModel>? receiverData;

  ChatsModel(
      {required this.chatType,
      required this.latestMessage,
      required this.timeStamp,
      required this.users,
      this.receiverData,
      this.id});

  factory ChatsModel.fromJson(Map<String, dynamic> json) =>
      _$ChatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatsModelToJson(this);
}
