import 'package:json_annotation/json_annotation.dart';

part 'users.g.dart';

@JsonSerializable()
class Users {
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

  Users(
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

  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);

  Map<String, dynamic> toJson() => _$UsersToJson(this);
}
