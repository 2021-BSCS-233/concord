import 'package:concord/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/models/users_model.dart';
import 'package:concord/services/firebase_services.dart';

class SignInController extends GetxController {
  final MainController mainController = Get.find<MainController>();
  final MyAuthentication authentication = MyAuthentication();
  TextEditingController signInUsernameTextController = TextEditingController();
  TextEditingController signInDisplayTextController = TextEditingController();
  TextEditingController signInEmailTextController = TextEditingController();
  TextEditingController signInPassTextController = TextEditingController();
  var hidePassword = true.obs;
  var showWaitOverlay = false.obs;
  String failMessage = '';

  sendSignIn() async {
    String user = signInUsernameTextController.text.trim().toLowerCase();
    String email = signInEmailTextController.text.trim();
    String pass = signInPassTextController.text.trim();
    String display = signInDisplayTextController.text.trim();
    showWaitOverlay.value = true;
    if (RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*?$').hasMatch(user) &&
        user.length >= 3 &&
        user.length <= 20 &&
        RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email) &&
        RegExp(r'.{8,}').hasMatch(pass)) {
      mainController.currentUserData = UsersModel(
        username: user,
        email: email,
        displayName: display != '' ? display : user,
        profilePicture: '',
        status: 'Online',
        displayStatus: 'Online',
        pronouns: '',
        aboutMe: '',
        friends: [],
        followingPosts: [],
        statusText: '',
        idle: false,
        bannerImg: '',
        bannerColor: 0xFFFFFFFF,
      );
      var response = await authentication.signInUserFirebase(email, pass);
      if (response?[0]) {
        showWaitOverlay.value = false;
        return response?[0];
      } else {
        showWaitOverlay.value = false;
        errorMessage(response?[1]);
        return false;
      }
    } else {
      if (user == '') {
        failMessage = 'Pls Enter a Username';
      } else if (user.length < 3 || user.length > 20) {
        failMessage = 'Length of Username Must Between 3 to 20';
      } else if (!(RegExp(r'^[a-zA-Z][a-zA-Z0-9_]+?$').hasMatch(user))) {
        failMessage =
            'Username Must Start With An Alphabet And Can Only Container Letters, Numbers and \'_\'';
      }
      if (!(RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email))) {
        failMessage = "$failMessage\nInvalid Email Format";
      }
      if (!(RegExp(r'.{8,}').hasMatch(pass))) {
        failMessage = "$failMessage\nPassword Must be At Least 8 Characters";
      }
      showWaitOverlay.value = false;
      errorMessage(failMessage);
      return false;
    }
  }

  errorMessage(String text) {
    Get.defaultDialog(
      contentPadding:
          const EdgeInsetsGeometry.symmetric(horizontal: 30, vertical: 20),
      titlePadding: const EdgeInsetsGeometry.only(top: 10),
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
