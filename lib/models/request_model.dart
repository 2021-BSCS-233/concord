import 'package:concord/models/users_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_model.g.dart';

@JsonSerializable()
class RequestsModel {
  String senderId;
  String receiverId;
  @JsonKey(fromJson: _customDateFromJson, toJson: _customDateToJson)
  DateTime timeStamp;
  @JsonKey(includeToJson: false, includeFromJson: false)
  UsersModel? user;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? id;

  RequestsModel(
      {required this.senderId,
        required this.receiverId,
        required this.timeStamp,
        this.user,
        this.id});

  factory RequestsModel.fromJson(Map<String, dynamic> json) =>
      _$RequestsModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestsModelToJson(this);

  static DateTime _customDateFromJson(dynamic json) {
    return json.toDate();
  }
  static DateTime _customDateToJson(dynamic timeStamp) {
    return timeStamp;
  }
}