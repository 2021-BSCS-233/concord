import 'package:json_annotation/json_annotation.dart';

part 'messages_model.g.dart';

@JsonSerializable()
class MessagesModel {
  String senderId;
  @JsonKey(fromJson: _customDateFromJson, toJson: _customDateToJson)
  DateTime? timeStamp;
  String message;
  bool edited;
  List<String>? attachments;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? id;

  MessagesModel(
      {required this.senderId,
      required this.message,
      required this.edited,
      this.timeStamp,
      this.attachments,
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
