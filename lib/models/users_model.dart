import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'users_model.g.dart';

@JsonSerializable()
class UsersModel {
  String username;
  String email;
  String displayName;
  String profilePicture;
  String statusText;
  bool idle;
  String bannerImg;
  int bannerColor;
  String status;
  String displayStatus;
  String pronouns;
  String aboutMe;
  List<String> friends;
  List<String> preference;
  List<String> followingPosts;
  @JsonKey(includeToJson: false, includeFromJson: false)
  DocumentReference? docRef;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? id;

  UsersModel(
      {required this.username,
      required this.email,
      required this.displayName,
      required this.profilePicture,
      required this.statusText,
      required this.idle,
      required this.bannerImg,
      required this.bannerColor,
      required this.status,
      required this.displayStatus,
      required this.pronouns,
      required this.aboutMe,
      required this.friends,
      required this.preference,
      required this.followingPosts,
      this.docRef,
      this.id});

  factory UsersModel.fromJson(Map<String, dynamic> json) =>
      _$UsersModelFromJson(json);

  Map<String, dynamic> toJson() => _$UsersModelToJson(this);

// static Color _colorFromJson(dynamic json) {
//   return Color(int.parse('0xFF$json}'));
// }
//
// static String _colorToJson(Color color) {
//   return color.value.toRadixString(16);
// }
}

