import 'package:concord/models/messages_model.dart';
import 'package:concord/models/posts_model.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:concord/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NewPostController extends GetxController {
  final MyFirestore myFirestore = MyFirestore();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  List<String> categories = [];

  Future<bool> sendPost(posterId) async {
    APICalls apiCalls = APICalls();
    if (titleTextController.text.trim() == '' ||
        descriptionTextController.text.trim() == '') {
      debugPrint('pls fill all fields');
      return false;
    }
    String text =
        '${titleTextController.text.trim()}:${descriptionTextController.text.trim()}';

    categories = await apiCalls.classifyTextPerform(text);
    if (categories.isEmpty) {
      debugPrint('api response failed');
      return false;
    }
    PostsModel newPost = PostsModel(
        poster: posterId,
        title: titleTextController.text.trim(),
        description: descriptionTextController.text.trim(),
        topAttachment: '',
        categories: categories,
        followers: [posterId],
        participants: [posterId],
        allNotifications: [posterId],
        noNotifications: [],
        timeStamp: DateTime.now());
    MessagesModel firstMessage = MessagesModel(
        senderId: posterId,
        message: descriptionTextController.text.trim(),
        edited: false,
        pinged: [],
        attachments: []);
    return await myFirestore.sendPostFirebase(newPost, firstMessage, []);
  }
}
