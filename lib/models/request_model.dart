import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concord/models/users_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_model.g.dart';

@JsonSerializable()
class RequestsModel {
  String senderId;
  String receiverId;
  @JsonKey(fromJson: _docRefFromJson, toJson: _docRefToJson)
  DocumentReference senderDocRef;
  @JsonKey(fromJson: _docRefFromJson, toJson: _docRefToJson)
  DocumentReference receiverDocRef;
  @JsonKey(fromJson: _customDateFromJson, toJson: _customDateToJson)
  DateTime timeStamp;
  @JsonKey(includeToJson: false, includeFromJson: false)
  UsersModel? user;
  @JsonKey(includeToJson: false, includeFromJson: false)
  DocumentReference? docRef;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? id;

  RequestsModel(
      {required this.senderId,
      required this.senderDocRef,
      required this.receiverId,
      required this.receiverDocRef,
      required this.timeStamp,
      this.user,
      this.docRef,
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
  static DocumentReference _docRefFromJson(String json) {
    return FirebaseFirestore.instance.doc(json);
  }

  static String _docRefToJson(DocumentReference reference) {
    return reference.path;
  }
}
