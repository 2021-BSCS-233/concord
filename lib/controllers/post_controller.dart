import 'package:concord/controllers/main_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:concord/models/messages_model.dart';
import 'package:concord/services/firebase_services.dart';

class PostController extends GetxController {
  MainController mainController = Get.find<MainController>();
  String postId = '';
  List<MessagesModel> postContent = [];
  Map userMap = {};
  bool initial = true;
  bool editMode = false;
  int messageSelected = 0;
  var attachments = [];
  var showMenu = false.obs;
  var updateP = 0.obs;
  var updateA = 0.obs;
  var showProfile = false.obs;
  var sendVisible = false.obs;
  var attachmentVisible = false.obs;
  final postFocusNode = FocusNode();
  TextEditingController postFieldTextController = TextEditingController();

  // ChatController({required this.chatId});

  void toggleMenu(int index) {
    if (index != -1) {
      messageSelected = index;
    }
    showMenu.value = true;
  }

  void toggleProfile(int index) {
    if (index != -1) {
      messageSelected = index;
    }
    showProfile.value = !showProfile.value;
  }

  void sendVisibility() {
    if (!editMode && postFieldTextController.text.trim() != '') {
      sendVisible.value = true;
    } else if (editMode &&
        postFieldTextController.text.trim() !=
            postContent[messageSelected].message) {
      sendVisible.value = true;
    } else {
      sendVisible.value = false;
    }
  }

  getPostMessages(postId) async {
    postContent = await getInitialMessagesFirebase('posts', postId);
    mainController.chatListenerRef =
        messagesListenerFirebase('posts', postId, updateMessages);
    initial = false;
  }

  sendMessage(currentUserId) {
    sendVisible.value = false;
    attachmentVisible.value = false;
    if (editMode) {
      sendEditMessage();
    } else {
      MessagesModel messageData = MessagesModel(
          senderId: currentUserId,
          message: postFieldTextController.text.trim(),
          edited: false);
      sendMessageFirebase('posts',postId, messageData, attachments);
    }
    postFieldTextController.clear();
    attachments = [];
  }

  sendEditMessage() {
    editMessageFirebase('posts',postId, postContent[messageSelected].id,
        postFieldTextController.text.trim());
    postFocusNode.unfocus();
    editMode = false;
  }

  updateMessages(MessagesModel updateData, updateType) {
    var index = postContent.indexWhere((map) => map.id == updateData.id);
    if (updateType == 'added' && index < 0) {
      postContent.add(updateData);
    } else if (updateType == 'modified') {
      postContent[index].message = updateData.message;
      postContent[index].edited = true;
    } else if (updateType == 'removed') {
      postContent.removeAt(index);
    }
    updateP.value += 1;
  }

  editMessage() {
    showMenu.value = false;
    editMode = true;
    postFieldTextController.text = postContent[messageSelected].message;
    postFocusNode.requestFocus();
  }

  deleteMessage() {
    deleteMessageFirebase('posts',postId, postContent[messageSelected]);
    showMenu.value = false;
  }

  addAttachments() async {
    var results = await ImagePicker().pickMultiImage();
    if (results != []) {
      for (var result in results) {
        attachments.add(result);
      }
      attachmentVisible.value = true;
      sendVisible.value = true;
      updateA.value += 1;
    } else {
      attachmentVisible.value = false;
      sendVisible.value = false;
      updateA.value += 1;
      debugPrint('nothing selected');
    }
  }

  removeAttachment(index) {
    attachments.removeAt(index);
    if (attachments.isEmpty) {
      attachmentVisible.value = false;
      sendVisible.value = false;
    }
    updateA.value += 1;
  }
}
