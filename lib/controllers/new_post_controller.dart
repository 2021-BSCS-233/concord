import 'package:concord/models/messages_model.dart';
import 'package:concord/models/posts_model.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:concord/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPostController extends GetxController {
  final MyFirestore myFirestore = MyFirestore();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  List<String> categories = [];

  Future<bool> sendPost(posterId) async {
    APICalls apiCalls = APICalls();
    if (titleTextController.text.trim() == '' ||
        descriptionTextController.text.trim() == '') {
      errorMessage('Please fill all fields');
      return false;
    }
    String text =
        '${titleTextController.text.trim()}:${descriptionTextController.text.trim()}';

    categories = await apiCalls.classifyTextPerform(text);
    if (categories.isEmpty) {
      errorMessage(
          'There was an error during auto categorization. Please categorize the post manually or try again later');
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

  errorMessage(String text) {
    Get.defaultDialog(
      contentPadding:
          const EdgeInsetsGeometry.symmetric(horizontal: 30, vertical: 20),
      titlePadding: const EdgeInsetsGeometry.only(top: 10),
      backgroundColor: const Color(0xFF121212),
      barrierDismissible: false,
      title: 'Alert',
      titleStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: 'gg_sans',
          color: Colors.white),
      middleText: text,
      middleTextStyle: const TextStyle(
        fontFamily: 'gg_sans',
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      textCancel: "Close",
      cancelTextColor: Colors.white,
      confirmTextColor: Colors.white,
      buttonColor: const Color.fromARGB(255, 255, 77, 0),
    );
  }
}
