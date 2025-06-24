import 'package:concord/controllers/main_controller.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final MainController mainController = Get.find();
  final MyFirestore myFirestore = MyFirestore();
  TextEditingController displayTextController = TextEditingController();
  TextEditingController pronounceTextController = TextEditingController();
  TextEditingController aboutMeTextController = TextEditingController();
  String image = '';

  Future<void> updateProfile() async {
    await myFirestore.updateProfileFirebase(
        mainController.currentUserData.id,
        displayTextController.text.trim() != ''
            ? displayTextController.text.trim()
            : mainController.currentUserData.displayName,
        pronounceTextController.text.trim(),
        aboutMeTextController.text.trim(),
        image);
  }
}
