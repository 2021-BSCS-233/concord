import 'package:json_annotation/json_annotation.dart';

part 'users_model.g.dart';

@JsonSerializable()
class UsersModel {
  String username;
  String email;
  String displayName;
  String profilePicture;
  String status;
  String displayStatus;
  String pronouns;
  String aboutMe;
  List friends;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? id;

  UsersModel(
      {required this.username,
      required this.email,
      required this.displayName,
      required this.profilePicture,
      required this.status,
      required this.displayStatus,
      required this.pronouns,
      required this.aboutMe,
      required this.friends,
      this.id});

  factory UsersModel.fromJson(Map<String, dynamic> json) => _$UsersModelFromJson(json);

  Map<String, dynamic> toJson() => _$UsersModelToJson(this);
}
