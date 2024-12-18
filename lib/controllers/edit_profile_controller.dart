import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  TextEditingController displayTextController = TextEditingController();
  TextEditingController pronounceTextController = TextEditingController();
  TextEditingController aboutMeTextController = TextEditingController();
  String image = '';
}