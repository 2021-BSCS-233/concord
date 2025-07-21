import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/services/firebase_services.dart';

class LogInController extends GetxController {
  final MyAuthentication authentication = MyAuthentication();
  TextEditingController logInEmailTC = TextEditingController();
  TextEditingController logInPassTC = TextEditingController();
  var hidePassword = true.obs;
  var showWaitOverlay = false.obs;

  // var showMessageLogIn = false.obs;

  Future<bool> sendLogIn() async {
    var email = logInEmailTC.text.trim();
    var pass = logInPassTC.text.trim();
    showWaitOverlay.value = true;
    if (RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email) &&
        RegExp(r'.{8,}').hasMatch(pass)) {
      var response = await authentication.logInUserFirebase(email, pass);
      debugPrint('error: $response');
      if (response) {
        showWaitOverlay.value = false;
      } else {
        showWaitOverlay.value = false;
        errorMessage('Incorrect Email or Password Input');
      }
      return response;
    } else {
      showWaitOverlay.value = false;
      errorMessage('Invalid Email or Password');
      return false;
    }
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
