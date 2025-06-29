import 'package:concord/models/settings_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  late SettingsModel settingsModel;
  var showMenu = false.obs;

  TextEditingController usernameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  void toggleMenu() {
    showMenu.value = !showMenu.value;
  }
}