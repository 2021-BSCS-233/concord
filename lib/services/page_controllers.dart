import 'package:concord/models/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:image_picker/image_picker.dart';

class MainController extends GetxController {
  late Users currentUserData;
  var updateM = 0.obs;
  var showMenu = false.obs;
  var showProfile = false.obs;
  var selectedIndex = 0.obs;
  var selectedUsername = '';
  var selectedUserId = '';
  var selectedUserPic = '';
  var selectedChatType = '';

  // MainController({required this.currentUserData});

  void toggleMenu(dataList) {
    selectedUserId = dataList[0];
    selectedUsername = dataList[1];
    selectedUserPic = dataList[2];
    selectedChatType = dataList[3];
    showMenu.value = !showMenu.value;
  }

  void toggleProfile(data) {
    selectedUserId = data;
    showProfile.value = !showProfile.value;
  }
}

class SignInController extends GetxController {
  MainController mainController = Get.find<MainController>();
  TextEditingController signInUsernameTextController = TextEditingController();
  TextEditingController signInDisplayTextController = TextEditingController();
  TextEditingController signInEmailTextController = TextEditingController();
  TextEditingController signInPassTextController = TextEditingController();

  var showOverlaySignIn = false.obs;
  var showMessageSignIn = false.obs;
  double messageHeightSignIn = 250;
  String failMessage = '';

  sendSignIn() async {
    String user = signInUsernameTextController.text.trim().toLowerCase();
    String email = signInEmailTextController.text.trim();
    String pass = signInPassTextController.text.trim();
    String display = signInDisplayTextController.text.trim();
    showOverlaySignIn.value = true;
    if (RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*?$').hasMatch(user) &&
        user.length >= 3 &&
        user.length <= 20 &&
        RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email) &&
        RegExp(r'.{8,}').hasMatch(pass)) {
      mainController.currentUserData = Users(
          username: user,
          email: email,
          displayName: display != '' ? display : user,
          profilePicture: '',
          status: 'Online',
          displayStatus: 'Online',
          pronouns: '',
          aboutMe: '',
          friends: []);
      var response = await signInUser(email, pass);
      if (response?[0]) {
        await saveUserOnDevice(email, signInPassTextController.text.trim());
        showOverlaySignIn.value = false;
        return response?[0];
      } else {
        failMessage = '• ${response?[1]}';
        showOverlaySignIn.value = true;
        showMessageSignIn.value = true;
        return false;
      }
    } else {
      if (user == '') {
        failMessage = '• Pls Enter a Username';
      } else if (user.length < 3 || user.length > 20) {
        failMessage = '• Length of Username Must Between 3 to 20';
      } else if (!(RegExp(r'^[a-zA-Z][a-zA-Z0-9_]+?$').hasMatch(user))) {
        failMessage =
            '• Username Must Start With An Alphabet And Can Only Container Letters, Numbers and \'_\'';
        messageHeightSignIn += 15;
      }
      if (!(RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email))) {
        failMessage = "$failMessage\n• Invalid Email Format";
        messageHeightSignIn += 10;
      }
      if (!(RegExp(r'.{8,}').hasMatch(pass))) {
        failMessage = "$failMessage\n• Password Must be At Least 8 Characters";
        messageHeightSignIn += 10;
      }
      showOverlaySignIn.value = true;
      showMessageSignIn.value = true;
      return false;
    }
  }
}

class LogInController extends GetxController {
  TextEditingController logInEmailTextController = TextEditingController();
  TextEditingController logInPassTextController = TextEditingController();
  var showOverlayLogIn = false.obs;
  var showMessageLogIn = false.obs;

  Future<bool> sendLogIn() async {
    var email = logInEmailTextController.text.trim();
    var pass = logInPassTextController.text.trim();
    showOverlayLogIn.value = true;
    if (RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email) &&
        RegExp(r'.{8,}').hasMatch(pass)) {
      var response = await logInUser(email, pass);
      if (response) {
        await saveUserOnDevice(email, pass);
        showOverlayLogIn.value = false;
      } else {
        showOverlayLogIn.value = true;
        showMessageLogIn.value = true;
      }
      return response;
    } else {
      return false;
    }
  }
}

class FriendsController extends GetxController {
  bool initial = true;
  var updateF = 0.obs;
  var friendsListenerRef;
  List friendsData = [];

  getInitialData(currentUserId) async {
    friendsListenerRef = await friendsListener(
      currentUserId,
    );
    friendsData = await getInitialFriends(currentUserId);
    initial = false;
  }

  updateFriends(updateData, updateType) {
    var index = friendsData.indexWhere((map) => map['id'] == updateData['id']);
    if (updateType == 'modified') {
      friendsData[index] = updateData;
    } else if (updateType == 'added' && index < 0) {
      friendsData.insert(0, updateData);
    } else if (updateType == 'removed') {
      friendsData.removeAt(index);
    }
    updateF.value += 1;
  }
}

class ChatsController extends GetxController {
  var updateCs = 0.obs;
  bool initial = true;
  var chatsListenerRef;
  List chatsData = [];

  getInitialData(currentUserId) async {
    chatsListenerRef = await chatsListener(currentUserId, updateChats);
    chatsData = await getInitialChats(currentUserId);
    initial = false;
  }

  updateChats(updateData, updateType) {
    var index = chatsData.indexWhere((map) => map['id'] == updateData['id']);
    if (updateType == 'modified') {
      chatsData[index]['latest_message'] = updateData['latest_message'];
      chatsData[index]['time_stamp'] = updateData['time_stamp'];
    } else if (updateType == 'added' && index < 0) {
      chatsData.insert(0, updateData);
    }
    // update.value += 1;
  }
}

var generalImages = CacheManager(Config(
  'generalImageCache',
  stalePeriod: const Duration(days: 7),
  maxNrOfCacheObjects: 50,
));

class ChatController extends GetxController {
  var chatId = '';
  var chatContent = [];
  var messagesListenerRef;
  var userMap = {};
  var lastSender = '';
  var initial = true;
  var editMode = false;
  var messageSelected = 0;
  var attachments = [];
  var showMenu = false.obs;
  var updateC = 0.obs;
  var updateA = 0.obs;
  var showProfile = false.obs;
  var sendVisible = false.obs;
  var attachmentVisible = false.obs;
  final chatFocusNode = FocusNode();
  TextEditingController chatFieldController = TextEditingController();

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
    if (!editMode && chatFieldController.text.trim() != '') {
      sendVisible.value = true;
    } else if (editMode &&
        chatFieldController.text.trim() !=
            chatContent[messageSelected]['message']) {
      sendVisible.value = true;
    } else {
      sendVisible.value = false;
    }
    // sendVisible.value = (!editMode && chatFieldController.text.trim() != ''
    //     ? true
    //     : editMode &&
    //             chatFieldController.text.trim() !=
    //                 chatContent[messageSelected]['message']
    //         ? true
    //         : false);
  }

  getMessages(chatId) async {
    messagesListenerRef = await messagesListener(chatId);
    chatContent = await getInitialMessages(chatId);
    initial = false;
  }

  sendMessage(currentUserId) {
    sendVisible.value = false;
    attachmentVisible.value = false;
    editMode
        ? sendEditMessage()
        : sendMessageFirebase(
            chatId, chatFieldController.text, currentUserId, attachments);
    chatFieldController.clear();
    attachments = [];
  }

  sendEditMessage() {
    editMessageFirebase(
        chatId, chatContent[messageSelected]['id'], chatFieldController.text);
    chatFocusNode.unfocus();
    editMode = false;
  }

  updateMessages(updateData, updateType) {
    var index = chatContent.indexWhere((map) => map['id'] == updateData['id']);
    if (updateType == 'added' && index < 0) {
      chatContent.insert(0, updateData);
    } else if (updateType == 'modified') {
      chatContent[index]['message'] = updateData['message'];
      chatContent[index]['edited'] = true;
    } else if (updateType == 'removed') {
      chatContent.removeAt(index);
    }
    updateC.value += 1;
  }

  editMessage() {
    showMenu.value = false;
    editMode = true;
    chatFieldController.text = chatContent[messageSelected]['message'];
    chatFocusNode.requestFocus();
  }

  deleteMessage() {
    deleteMessageFirebase(chatId, chatContent[messageSelected]['id']);
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

class RequestsController extends GetxController {
  var updateI = 0.obs;
  var updateO = 0.obs;
  var initial = true;
  List incomingRequestsData = [];
  List outgoingRequestsData = [];
  var fieldCheck = false.obs;
  TextEditingController requestsFieldController = TextEditingController();

  void changing() {
    fieldCheck.value = (requestsFieldController.text != '' ? true : false);
  }

  getInitialData(currentUserId) async {
    requestsListeners(currentUserId);
    var result = await getInitialRequest(currentUserId);
    incomingRequestsData = result[0];
    outgoingRequestsData = result[1];
    initial = false;
  }

  updateIncomingRequests(updateData, updateType) {
    var index =
        incomingRequestsData.indexWhere((map) => map['id'] == updateData['id']);
    if (updateType == 'added' && index < 0) {
      incomingRequestsData.insert(0, updateData);
    } else if (updateType == 'removed') {
      incomingRequestsData.removeAt(index);
    }
    updateI.value += 1;
  }

  updateOutgoingRequests(updateData, updateType) {
    var index =
        outgoingRequestsData.indexWhere((map) => map['id'] == updateData['id']);
    if (updateType == 'added' && index < 0) {
      outgoingRequestsData.insert(0, updateData);
    } else if (updateType == 'removed') {
      outgoingRequestsData.removeAt(index);
    }
    updateO.value += 1;
  }
}

class EditProfileController extends GetxController {
  TextEditingController displayController = TextEditingController();
  TextEditingController pronounceController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  var image;
  var updateP = 0.obs;
}

class SettingsController extends GetxController {
  var showMenu = false.obs;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void toggleMenu() {
    showMenu.value = !showMenu.value;
  }
}
