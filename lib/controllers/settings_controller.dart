import 'package:concord/models/settings_model.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  SettingsModel userSettings;
  var selectedLang = 0.obs;
  SettingsController({required this.userSettings});

  final MyFirestore myFirestore = MyFirestore();
  bool didChange = false;
  Rx<bool> showMenu = false.obs;

  TextEditingController usernameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  void toggleMenu() {
    showMenu.value = !showMenu.value;
  }
  void saveSettings(){
    if(didChange) {
      myFirestore.saveSettingsFirebase(userSettings);
    }
  }
}