import 'package:concord/controllers/main_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:concord/models/messages_model.dart';
import 'package:concord/services/firebase_services.dart';

class ChatController extends GetxController {
  MainController mainController = Get.find<MainController>();
  String chatId = '';
  List<MessagesModel> chatContent = [];
  Map userMap = {};
  String lastSender = '';
  bool initial = true;
  bool editMode = false;
  int messageSelected = 0;
  var attachments = [];
  var showMenu = false.obs;
  var updateC = 0.obs;
  var updateA = 0.obs;
  var showProfile = false.obs;
  var sendVisible = false.obs;
  var attachmentVisible = false.obs;
  final chatFocusNode = FocusNode();
  TextEditingController chatFieldTextController = TextEditingController();

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
    if (!editMode && chatFieldTextController.text.trim() != '') {
      sendVisible.value = true;
    } else if (editMode &&
        chatFieldTextController.text.trim() !=
            chatContent[messageSelected].message) {
      sendVisible.value = true;
    } else {
      sendVisible.value = false;
    }
  }

  getMessages(chatId) async {
    mainController.chatListenerRef =
        messagesListenerFirebase('chats', chatId, updateMessages);
    chatContent = await getInitialMessagesFirebase('chats', chatId);
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
          message: chatFieldTextController.text.trim(),
          edited: false);
      sendMessageFirebase('chats',chatId, messageData, attachments);
    }
    chatFieldTextController.clear();
    attachments = [];
  }

  sendEditMessage() {
    editMessageFirebase('chats',chatId, chatContent[messageSelected].id,
        chatFieldTextController.text.trim());
    chatFocusNode.unfocus();
    editMode = false;
  }

  updateMessages(MessagesModel updateData, updateType) {
    var index = chatContent.indexWhere((map) => map.id == updateData.id);
    if (updateType == 'added' && index < 0) {
      chatContent.insert(0, updateData);
    } else if (updateType == 'modified' && !(index < 0)) {
      chatContent[index].message = updateData.message;
      chatContent[index].edited = true;
    } else if (updateType == 'removed' && !(index < 0)) {
      chatContent.removeAt(index);
    }
    updateC.value += 1;
  }

  editMessage() {
    showMenu.value = false;
    editMode = true;
    chatFieldTextController.text = chatContent[messageSelected].message;
    chatFocusNode.requestFocus();
  }

  deleteMessage() {
    deleteMessageFirebase('chats',chatId, chatContent[messageSelected].id);
    showMenu.value = false;
  }

  addAttachments() async {
    attachments = await ImagePicker().pickMultiImage();
    if (attachments.isNotEmpty) {
      attachmentVisible.value = true;
      sendVisible.value = true;
      updateA.value += 1;
    } else {
      attachmentVisible.value = false;
      sendVisible.value = false;
      updateA.value += 1;
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
