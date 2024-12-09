import 'package:concord/models/users_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'posts_model.g.dart';

@JsonSerializable()
class PostsModel {
  String poster;
  String title;
  String description;
  List<String> attachments;
  List<String> categories;
  List<String> followers;
  @JsonKey(fromJson: _customDateFromJson, toJson: _customDateToJson)
  DateTime timeStamp;
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
        required this.attachments,
        required this.categories,
        required this.followers,
        required this.timeStamp,
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