import 'dart:async';
import 'package:concord/models/users_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:concord/pages/login_page.dart';

class MainController extends GetxController {
  late UsersModel currentUserData;
  var selectedIndex = 0.obs;
  var showMenu = false.obs;
  var showStatus = false.obs;
  var showProfile = false.obs;
  var selectedChatId = '';
  var selectedUserId = '';
  var selectedUserPic = '';
  var selectedUsername = '';
  var selectedChatType = '';
  StreamSubscription? profileListenerRef;
  StreamSubscription? chatsListenerRef;
  StreamSubscription? friendsListenerRef;
  StreamSubscription? chatListenerRef;
  StreamSubscription? requestListenerRef;

  // MainController({required this.currentUserData});

  void toggleMenu(dataList) {
    selectedChatId = dataList[0];
    selectedUserId = dataList[1];
    selectedUsername = dataList[2];
    selectedUserPic = dataList[3];
    selectedChatType = dataList[4];
    showMenu.value = true;
  }

  void toggleStatus(){
    showStatus.value = true;
  }

  void toggleProfile(data) {
    selectedUserId = data;
    showProfile.value = true;
  }

  logOut() async {
    chatsListenerRef?.cancel();
    profileListenerRef?.cancel();
    friendsListenerRef?.cancel();
    requestListenerRef?.cancel();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    Get.deleteAll();
    Get.offAll(LogInPage());
  }
}
