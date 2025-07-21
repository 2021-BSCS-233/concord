import 'package:concord/models/messages_model.dart';
import 'package:concord/models/posts_model.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:concord/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPostController extends GetxController {
  final MyFirestore myFirestore = MyFirestore();
  TextEditingController titleTC = TextEditingController();
  TextEditingController descriptionTC = TextEditingController();
  List<String> categories = [];
  var autoCat = true.obs;
  var showWaitOverlay = false.obs;

  Future<bool> sendPost(posterId) async {
    showWaitOverlay.value = true;
    APICalls apiCalls = APICalls();
    if (titleTC.text.trim() == '' ||
        descriptionTC.text.trim() == '') {
      errorMessage('Please fill all fields');
      showWaitOverlay.value = false;
      return false;
    }
    String text =
        '${titleTC.text.trim()}:${descriptionTC.text.trim()}';
    if (autoCat.value) {
      categories = await apiCalls.classifyTextPerform(text);
      if (categories.isEmpty) {
        errorMessage(
            'There was an error during auto categorization. Please categorize the post manually or try again later');
        showWaitOverlay.value = false;
        return false;
      }
      //else show the cats to user to verify
    } else {
      if (categories.isEmpty) {
        errorMessage('Please Select Categories');
        showWaitOverlay.value = false;
        return false;
      }
    }
    PostsModel newPost = PostsModel(
        poster: posterId,
        title: titleTC.text.trim(),
        description: descriptionTC.text.trim(),
        topAttachment: '',
        categories: categories,
        followers: [posterId],
        participants: [posterId],
        allNotifications: [posterId],
        noNotifications: [],
        timeStamp: DateTime.now());
    MessagesModel firstMessage = MessagesModel(
        senderId: posterId,
        message: descriptionTC.text.trim(),
        edited: false,
        pinged: [],
        attachments: []);
    bool response = await myFirestore.sendPostFirebase(newPost, firstMessage, []);
    showWaitOverlay.value = false;
    return response;
  }

  errorMessage(String text) {
    Get.defaultDialog(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      titlePadding: const EdgeInsets.only(top: 10),
      backgroundColor: const Color(0xFF121212),
      barrierDismissible: true,
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
