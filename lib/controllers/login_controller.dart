import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:concord/services/firebase_services.dart';

class LogInController extends GetxController {
  final MyAuthentication authentication = MyAuthentication();
  TextEditingController logInEmailTextController = TextEditingController();
  TextEditingController logInPassTextController = TextEditingController();
  var hidePassword = true.obs;
  var showOverlayLogIn = false.obs;
  var showMessageLogIn = false.obs;

  Future<bool> sendLogIn() async {
    var email = logInEmailTextController.text.trim();
    var pass = logInPassTextController.text.trim();
    showOverlayLogIn.value = true;
    if (RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email) &&
        RegExp(r'.{8,}').hasMatch(pass)) {
      var response = await authentication.logInUserFirebase(email, pass);
      debugPrint('error: $response');
      if (response) {
        await authentication.saveUserOnDevice(email, pass);
        showOverlayLogIn.value = false;
      } else {
        showOverlayLogIn.value = true;
        showMessageLogIn.value = true;
      }
      return response;
    } else {
      showOverlayLogIn.value = true;
      showMessageLogIn.value = true;
      return false;
    }
  }
}