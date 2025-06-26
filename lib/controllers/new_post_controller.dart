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
  TextEditingController debugCategoriesTextController = TextEditingController();
  List<String> categories = [];

  Future<bool> sendPost(posterId) async {
    APICalls apiCalls = APICalls();
    String text =
        '${titleTextController.text.trim()}:${descriptionTextController.text.trim()}';

    categories = await apiCalls.classifyTextPerform(text);
    if(categories.isEmpty){
      return false;
    } else {
      // categories = debugCategoriesTextController.text.trim().split(',');
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
      await myFirestore.sendPostFirebase(newPost, firstMessage, []);
      return true;
    }
  }
}
