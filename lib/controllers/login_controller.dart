import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/services/firebase_services.dart';

class LogInController extends GetxController {
  final MyAuthentication authentication = MyAuthentication();
  TextEditingController logInEmailTextController = TextEditingController();
  TextEditingController logInPassTextController = TextEditingController();
  var hidePassword = true.obs;
  var showOverlayLogIn = false.obs;

  // var showMessageLogIn = false.obs;

  Future<bool> sendLogIn() async {
    var email = logInEmailTextController.text.trim();
    var pass = logInPassTextController.text.trim();
    showOverlayLogIn.value = true;
    if (RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email) &&
        RegExp(r'.{8,}').hasMatch(pass)) {
      var response = await authentication.logInUserFirebase(email, pass);
      debugPrint('error: $response');
      if (response) {
        showOverlayLogIn.value = false;
      } else {
        showOverlayLogIn.value = false;
        errorMessage('Incorrect Email or Password Input');
      }
      return response;
    } else {
      showOverlayLogIn.value = false;
      errorMessage('Invalid Email or Password');
      return false;
    }
  }

  errorMessage(String text) {
    Get.defaultDialog(
      contentPadding:
          const EdgeInsetsGeometry.symmetric(horizontal: 30, vertical: 20),
      titlePadding: const EdgeInsetsGeometry.only(top: 10),
      backgroundColor: const Color(0xFF121212),
      barrierDismissible: false,
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
