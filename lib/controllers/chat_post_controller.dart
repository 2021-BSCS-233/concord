import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/models/users_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:concord/models/messages_model.dart';
import 'package:concord/services/firebase_services.dart';

class PostController extends GetxController {
  final MainController mainController = Get.find<MainController>();
  final MyFirestore myFirestore = MyFirestore();
  MessagesModel messageSelected = MessagesModel(
      senderId: '', message: '', edited: false, pinged: [], attachments: []);
  List<MessagesModel> chatContent = [];
  Map<String, UsersModel> userMap = {};
  DocumentReference? docRef;
  Map replyingTo = {};
  String collection;
  bool initial = true;
  var attachments = [];
  var editMode = false.obs;
  var replyMode = false.obs;
  var uploadCount = 0.obs;
  var showMenu = false.obs;
  var showProfile = false.obs;
  var sendVisible = false.obs;
  var attachmentVisible = false.obs;
  final chatFocusNode = FocusNode();
  TextEditingController chatFieldTC = TextEditingController();

  PostController({required this.collection});

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  void toggleMenu(MessagesModel message) {
    messageSelected = message;
    showMenu.value = true;
  }

  void toggleProfile(message) {
    messageSelected = message;
    showProfile.value = true;
  }

  getMessages() async {
    chatContent = await myFirestore.getInitialMessagesFirebase(docRef!);
    mainController.chatListenerRef ??= myFirestore.messagesListenerFirebase(
        docRef!, chatContent.first.timeStamp!, updateMessages);
    initial = false;
  }

  void sendVisibility() {
    if (!editMode.value && chatFieldTC.text.trim() != '') {
      sendVisible.value = true;
    } else if (editMode.value &&
        chatFieldTC.text.trim() != messageSelected.message &&
        chatFieldTC.text.trim() != '') {
      sendVisible.value = true;
    } else {
      sendVisible.value = false;
    }
  }

  updateMessages(MessagesModel updateData, updateType) async {
    if (updateData.timeStamp!.isAfter(chatContent.last.timeStamp!) ||
        updateData.timeStamp!.isAtSameMomentAs(chatContent.last.timeStamp!)) {
      if (userMap[updateData.senderId] != null) {
        userMap[updateData.senderId] =
            await myFirestore.getUserProfileFirebase(updateData.senderId);
      }
      var index = chatContent.indexWhere((map) => map.id == updateData.id);
      if (updateType == 'added' && index < 0) {
        chatContent.insert(0, updateData);
      } else if (updateType == 'modified' && !(index < 0)) {
        chatContent[index].message = updateData.message;
        chatContent[index].edited = updateData.edited;
      } else if (updateType == 'removed' && !(index < 0)) {
        chatContent.removeAt(index);
      }
      update(['chatSection']);
    }
  }

  enterEditMode() {
    attachments = [];
    attachmentVisible.value = false;
    replyMode.value = false;
    showMenu.value = false;
    editMode.value = true;
    chatFieldTC.text = messageSelected.message;
    chatFocusNode.requestFocus();
    // update(['editReplyMode']);
  }

  exitEditMode() {
    editMode.value = false;
    chatFieldTC.text = '';
    chatFocusNode.unfocus();
    // update(['editReplyMode']);
  }

  enterReplyMode() {
    showMenu.value = false;
    editMode.value = false;
    replyMode.value = true;
    replyingTo['user'] = userMap[messageSelected.senderId]!.displayName;
    replyingTo['messageId'] = messageSelected.id;
    chatFocusNode.requestFocus();
    // update(['editReplyMode']);
  }

  exitReplyMode() {
    replyMode.value = false;
    replyingTo.clear();
    // update(['editReplyMode']);
  }

  sendMessage(currentUserId) async {
    sendVisible.value = false;
    attachmentVisible.value = false;
    if (editMode.value) {
      sendEditedMessage();
    } else {
      MessagesModel messageData = MessagesModel(
          senderId: currentUserId,
          message: chatFieldTC.text.trim(),
          edited: false,
          repliedTo: replyingTo['messageId'],
          pinged: [],
          attachments: []);
      chatFieldTC.clear();
      replyMode.value = false;
      replyingTo.clear();
      attachments.isNotEmpty ? uploadCount++ : null;
      await myFirestore.sendMessageFirebase(
          collection, docRef!, messageData, attachments);
      attachments.isNotEmpty ? uploadCount-- : null;
    }
    attachments = [];
  }

  sendEditedMessage() {
    myFirestore.editMessageFirebase(
        messageSelected.docRef!, chatFieldTC.text.trim());
    chatFieldTC.clear();
    chatFocusNode.unfocus();
    editMode.value = false;
    // update(['editReplyMode']);
  }

  deleteMessage() {
    myFirestore.deleteMessageFirebase(messageSelected);
    showMenu.value = false;
  }

  addAttachments() async {
    if (!editMode.value) {
      var results = await ImagePicker().pickMultiImage();
      if (results != []) {
        for (var result in results) {
          attachments.add(result);
        }
        attachmentVisible.value = true;
        sendVisible.value = true;
      } else {
        attachmentVisible.value = false;
        sendVisible.value = false;
      }
    }
  }

  removeAttachment(index) {
    attachments.removeAt(index);
    if (attachments.isEmpty) {
      attachmentVisible.value = false;
      sendVisible.value = false;
    }
    update(['attachmentList']);
  }
}

class ChatController extends PostController {
  String lastSender = '';
  bool historyRemaining = true;
  List<MessagesModel> chatHistory = [];

  ChatController({required super.collection});

  getMessageHistory() async {
    var result = await myFirestore.getMessageHistoryFirebase(
        docRef!, chatHistory.isEmpty ? chatContent.last : chatHistory.last);
    chatHistory.addAll(result[0]);
    historyRemaining = result[1];
    update(['chatHistory']);
  }
}
