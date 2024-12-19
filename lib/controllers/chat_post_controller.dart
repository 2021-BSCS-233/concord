import 'package:concord/controllers/main_controller.dart';
import 'package:concord/models/users_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:concord/models/messages_model.dart';
import 'package:concord/services/firebase_services.dart';

class PostController extends GetxController {
  MainController mainController = Get.find<MainController>();
  MessagesModel messageSelected =
      MessagesModel(senderId: '', message: '', edited: false);
  List<MessagesModel> chatContent = [];
  Map<String, UsersModel> userMap = {};
  Map replyingTo = {};
  String chatId = '';
  String collection;
  bool initial = true;
  var attachments = [];
  var uploadCount = 0.obs;
  var editMode = false.obs;
  var showMenu = false.obs;
  var replyMode = false.obs;
  var showProfile = false.obs;
  var sendVisible = false.obs;
  var attachmentVisible = false.obs;
  final chatFocusNode = FocusNode();
  TextEditingController chatFieldTextController = TextEditingController();

  PostController({required this.collection});

  void toggleMenu(MessagesModel message) {
    messageSelected = message;
    showMenu.value = true;
  }

  void toggleProfile(message) {
    messageSelected = message;
    showProfile.value = true;
  }

  getMessages() async {
    chatContent = await getInitialMessagesFirebase(collection, chatId);
    mainController.chatListenerRef =
        messagesListenerFirebase(collection, chatId, updateMessages);
    initial = false;
  }

  void sendVisibility() {
    if (!editMode.value && chatFieldTextController.text.trim() != '') {
      sendVisible.value = true;
    } else if (editMode.value &&
        chatFieldTextController.text.trim() != messageSelected.message &&
        chatFieldTextController.text.trim() != '') {
      sendVisible.value = true;
    } else {
      sendVisible.value = false;
    }
  }

  updateMessages(MessagesModel updateData, updateType) {
    if (updateData.timeStamp!.isAfter(chatContent.last.timeStamp!) ||
        updateData.timeStamp!.isAtSameMomentAs(chatContent.last.timeStamp!)) {
      var index = chatContent.indexWhere((map) => map.id == updateData.id);
      if (updateType == 'added' && index < 0) {
        collection == 'posts'
            ? chatContent.add(updateData)
            : chatContent.insert(0, updateData);
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
    chatFieldTextController.text = messageSelected.message;
    chatFocusNode.requestFocus();
  }

  exitEditMode() {
    editMode.value = false;
    chatFieldTextController.text = '';
    chatFocusNode.unfocus();
  }

  enterReplyMode() {
    showMenu.value = false;
    editMode.value = false;
    replyMode.value = true;
    replyingTo['user'] = userMap[messageSelected.senderId]!.displayName;
    replyingTo['messageId'] = messageSelected.id;
    chatFocusNode.requestFocus();
  }

  exitReplyMode() {
    replyMode.value = false;
    replyingTo.clear();
  }

  sendMessage(currentUserId) async {
    sendVisible.value = false;
    attachmentVisible.value = false;
    if (editMode.value) {
      sendEditedMessage();
    } else {
      MessagesModel messageData = MessagesModel(
          senderId: currentUserId,
          message: chatFieldTextController.text.trim(),
          edited: false,
          repliedTo: replyingTo['messageId']);
      chatFieldTextController.clear();
      replyMode.value = false;
      replyingTo.clear();
      attachments.isNotEmpty ? uploadCount++ : null;
      await sendMessageFirebase(collection, chatId, messageData, attachments);
      attachments.isNotEmpty ? uploadCount-- : null;
    }
    attachments = [];
  }

  sendEditedMessage() {
    editMessageFirebase(collection, chatId, messageSelected.id,
        chatFieldTextController.text.trim());
    chatFieldTextController.clear();
    chatFocusNode.unfocus();
    editMode.value = false;
  }

  deleteMessage() {
    deleteMessageFirebase(collection, chatId, messageSelected);
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
        debugPrint('nothing selected');
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
    var result = await getMessageHistoryFirebase(collection, chatId,
        chatHistory.isEmpty ? chatContent.last : chatHistory.last);
    chatHistory.addAll(result[0]);
    historyRemaining = result[1];
    update(['chatHistory']);
  }
}
