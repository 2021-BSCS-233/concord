import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concord/models/users_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'posts_model.g.dart';

@JsonSerializable()
class PostsModel {
  String poster;
  String title;
  String description;
  // List<String> attachments;
  List<String> categories;
  List<String> followers;
  List<String> participants;
  List<String> allNotifications;
  List<String> noNotifications;
  @JsonKey(fromJson: _customDateFromJson, toJson: _customDateToJson)
  DateTime timeStamp;
  @JsonKey(includeToJson: false, includeFromJson: false)
  DocumentReference? docRef;
  @JsonKey(includeToJson: false, includeFromJson: false)
  UsersModel? posterData;
  @JsonKey(includeToJson: false, includeFromJson: false)
  List<UsersModel>? receiverData;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? id;

  PostsModel(
      {required this.poster,
        required this.title,
        required this.description,
        // required this.attachments,
        required this.categories,
        required this.followers,
        required this.participants,
        required this.allNotifications,
        required this.noNotifications,
        required this.timeStamp,
        this.docRef,
        this.posterData,
        this.receiverData,
        this.id});

  factory PostsModel.fromJson(Map<String, dynamic> json) =>
      _$PostsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostsModelToJson(this);

  static DateTime _customDateFromJson(dynamic json){
    return json.toDate();
  }
  static DateTime _customDateToJson(dynamic timeStamp) {
    return timeStamp;
  }
}

// sub collection of notification settings for each user? (complex)
// or just a simple field? (limited options)
// simple field it is
// also a field for no notifications at all maybe, not ever pings