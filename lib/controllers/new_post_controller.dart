import 'package:concord/models/messages_model.dart';
import 'package:concord/models/posts_model.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:get/get.dart';

class NewPostController extends GetxController {
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController debugCategoriesTextController = TextEditingController();
  List<String> categories = [];

  sendPost(posterId) async {
    categories = debugCategoriesTextController.text.trim().split(',');
    PostsModel newPost = PostsModel(
        poster: posterId,
        title: titleTextController.text.trim(),
        description: descriptionTextController.text.trim(),
        attachments: [],
        categories: categories,
        followers: [posterId],
        participants: [posterId],
        timeStamp: DateTime.now());
    MessagesModel firstMessage = MessagesModel(
        senderId: posterId,
        message: descriptionTextController.text.trim(),
        edited: false);
    return await sendPostFirebase(newPost, firstMessage, []);
  }
}
