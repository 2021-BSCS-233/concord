import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  TextEditingController displayController = TextEditingController();
  TextEditingController pronounceController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  var image;
  var updateP = 0.obs;
}