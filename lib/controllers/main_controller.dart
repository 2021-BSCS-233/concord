import 'dart:async';
import 'package:concord/models/users_model.dart';
import 'package:flutter/material.dart';
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
  StreamSubscription? notificationListenerRef;
  Timer? overlayTimer;
  OverlayEntry? currentOverlayEntry;

  void toggleMenu(dataList) {
    selectedChatId = dataList[0];
    selectedUserId = dataList[1];
    selectedUsername = dataList[2];
    selectedUserPic = dataList[3];
    selectedChatType = dataList[4];
    showMenu.value = true;
  }

  void toggleStatus() {
    showStatus.value = true;
  }

  void toggleProfile(data) {
    selectedUserId = data;
    showProfile.value = true;
  }

  void showOverlay(BuildContext context, String overlayText) {
    void removeCurrentOverlay() {
      currentOverlayEntry?.remove();
      currentOverlayEntry = null;
    }

    overlayTimer?.cancel();
    removeCurrentOverlay();

    currentOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.sizeOf(context).height * 0.05,
        left: MediaQuery.sizeOf(context).width * 0.1,
        child: Material(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            width: MediaQuery.sizeOf(context).width * 0.8,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Text(
                overlayText,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );

    // Insert the new overlay entry
    Overlay.of(context).insert(currentOverlayEntry!);

    // Schedule removal after 5 seconds
    overlayTimer = Timer(const Duration(seconds: 5), () {
      removeCurrentOverlay();
    });
  }

  logOut() async {
    chatsListenerRef?.cancel();
    profileListenerRef?.cancel();
    friendsListenerRef?.cancel();
    requestListenerRef?.cancel();
    notificationListenerRef?.cancel();
    selectedIndex.value = 0;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    Get.deleteAll();
    Get.offAll(LogInPage());
  }
}
