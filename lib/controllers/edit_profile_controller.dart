import 'package:concord/controllers/main_controller.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final MainController mainController = Get.find();
  final MyFirestore myFirestore = MyFirestore();
  TextEditingController displayTC = TextEditingController();
  TextEditingController pronounceTC = TextEditingController();
  TextEditingController aboutMeTC = TextEditingController();
  String image = '';

  Future<void> updateProfile() async {
    await myFirestore.updateProfileFirebase(
        mainController.currentUserData.id,
        displayTC.text.trim() != ''
            ? displayTC.text.trim()
            : mainController.currentUserData.displayName,
        pronounceTC.text.trim(),
        aboutMeTC.text.trim(),
        image);
  }
}
