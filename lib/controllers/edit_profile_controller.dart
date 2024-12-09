import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  TextEditingController displayTextController = TextEditingController();
  TextEditingController pronounceTextController = TextEditingController();
  TextEditingController aboutMeTextController = TextEditingController();
  var image;
  var updateP = 0.obs;
}