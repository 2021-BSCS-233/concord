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

/* things to add in UI page
  account page:
    all usual stuff
  connections:
    ability to connect other accounts with a link to access them
  appearance:
    themes, light, dark, true dark,
    maybe: text size,
    change post attachment size,
  accessibility:
    toggle user colors,
    disable post attachments,
  language:
    options for various languages
  notifications:
    overall off,
    chat notifications section:
      posts created by friends,
      //will provide chat specific settings
      dms:
        all messages, nothing
      groups:
        all messages, pings, nothing
    post notifications section:
      //will provide post specific settings
      //over all toggle for following
      own created posts:
        all messages, only pings, nothing
      followed posts:
        all messages, only pings, nothing
      followed users:
        newly created posts, nothing
*/
