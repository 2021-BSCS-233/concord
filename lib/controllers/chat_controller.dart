import 'package:concord/controllers/main_controller.dart';
import 'package:concord/models/users_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:concord/models/messages_model.dart';
import 'package:concord/services/firebase_services.dart';

class ChatController extends GetxController {
  MainController mainController = Get.find<MainController>();
  String chatId = '';
  String lastSender = '';
  MessagesModel? messageSelected;
  bool initial = true;
  bool editMode = false;
  bool historyRemaining = true;
  var attachments = [];
  List<MessagesModel> chatContent = [];
  List<MessagesModel> chatHistory = [];
  Map<String, UsersModel> userMap = {};
  var updateC = 0.obs;
  var updateA = 0.obs;
  var showMenu = false.obs;
  var showProfile = false.obs;
  var sendVisible = false.obs;
  var attachmentVisible = false.obs;
  final chatFocusNode = FocusNode();
  TextEditingController chatFieldTextController = TextEditingController();

  // ChatController({required this.chatId});

  void toggleMenu(message) {
    if (message != null) {
      messageSelected = message;
    }
    showMenu.value = true;
  }

  void toggleProfile(message) {
    if (message != null) {
      messageSelected = message;
    }
    showProfile.value = true;
  }

  void sendVisibility() {
    if (!editMode && chatFieldTextController.text.trim() != '') {
      sendVisible.value = true;
    } else if (editMode &&
        chatFieldTextController.text.trim() !=
            messageSelected!.message) {
      sendVisible.value = true;
    } else {
      sendVisible.value = false;
    }
  }

  getMessages() async {
    chatContent = await getInitialMessagesFirebase('chats', chatId);
    mainController.chatListenerRef =
        messagesListenerFirebase('chats', chatId, updateMessages);
    initial = false;
  }

  getMessageHistory() async {
    var result = await getMessageHistoryFirebase('chats', chatId,
        chatHistory.isEmpty ? chatContent.last : chatHistory.last);
    chatHistory.addAll(result[0]);
    historyRemaining = result[1];
    updateC.value++;
  }

  sendMessage(currentUserId) {
    sendVisible.value = false;
    attachmentVisible.value = false;
    if (editMode) {
      sendEditMessage();
    } else {
      MessagesModel messageData = MessagesModel(
          senderId: currentUserId,
          message: chatFieldTextController.text.trim(),
          edited: false);
      sendMessageFirebase('chats', chatId, messageData, attachments);
    }
    chatFieldTextController.clear();
    attachments = [];
  }

  sendEditMessage() {
    editMessageFirebase('chats', chatId, messageSelected!.id,
        chatFieldTextController.text.trim());
    chatFocusNode.unfocus();
    editMode = false;
  }

  updateMessages(MessagesModel updateData, updateType) {
    var index = chatContent.indexWhere((map) => map.id == updateData.id);
    if (updateData.timeStamp!.isAfter(chatContent.last.timeStamp!) ||
        updateData.timeStamp!.isAtSameMomentAs(chatContent.last.timeStamp!)) {
      if (updateType == 'added' && index < 0) {
        chatContent.insert(0, updateData);
      } else if (updateType == 'modified' && !(index < 0)) {
        chatContent[index].message = updateData.message;
        chatContent[index].edited = updateData.edited;
      } else if (updateType == 'removed' && !(index < 0)) {
        chatContent.removeAt(index);
      }
      updateC.value++;
    }
  }

  editMessage() {
    showMenu.value = false;
    editMode = true;
    chatFieldTextController.text = messageSelected!.message;
    chatFocusNode.requestFocus();
  }

  deleteMessage() {
    deleteMessageFirebase('chats', chatId, messageSelected!);
    showMenu.value = false;
  }

  addAttachments() async {
    attachments = await ImagePicker().pickMultiImage();
    if (attachments.isNotEmpty) {
      attachmentVisible.value = true;
      sendVisible.value = true;
      updateA.value++;
    } else {
      attachmentVisible.value = false;
      sendVisible.value = false;
      updateA.value++;
    }
  }

  removeAttachment(index) {
    attachments.removeAt(index);
    if (attachments.isEmpty) {
      attachmentVisible.value = false;
      sendVisible.value = false;
    }
    updateA.value++;
  }
}
