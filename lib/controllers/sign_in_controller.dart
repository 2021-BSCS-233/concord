import 'package:concord/controllers/main_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:concord/models/users_model.dart';
import 'package:concord/services/firebase_services.dart';

class SignInController extends GetxController {
  final MainController mainController = Get.find<MainController>();
  final MyAuthentication authentication = MyAuthentication();
  TextEditingController signInUsernameTextController = TextEditingController();
  TextEditingController signInDisplayTextController = TextEditingController();
  TextEditingController signInEmailTextController = TextEditingController();
  TextEditingController signInPassTextController = TextEditingController();
  var hidePassword = true.obs;
  var showOverlaySignIn = false.obs;
  var showMessageSignIn = false.obs;
  double messageHeightSignIn = 250;
  String failMessage = '';

  sendSignIn() async {
    String user = signInUsernameTextController.text.trim().toLowerCase();
    String email = signInEmailTextController.text.trim();
    String pass = signInPassTextController.text.trim();
    String display = signInDisplayTextController.text.trim();
    showOverlaySignIn.value = true;
    if (RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*?$').hasMatch(user) &&
        user.length >= 3 &&
        user.length <= 20 &&
        RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email) &&
        RegExp(r'.{8,}').hasMatch(pass)) {
      mainController.currentUserData = UsersModel(
        username: user,
        email: email,
        displayName: display != '' ? display : user,
        profilePicture: '',
        status: 'Online',
        displayStatus: 'Online',
        pronouns: '',
        aboutMe: '',
        friends: [],
        preference: [],
        followingPosts: [],
        statusText: '',
        idle: false,
        bannerImg: '',
        bannerColor: 0xFFFFFFFF,
      );
      var response = await authentication.signInUserFirebase(email, pass);
      if (response?[0]) {
        await authentication.saveUserOnDevice(email, signInPassTextController.text.trim());
        showOverlaySignIn.value = false;
        return response?[0];
      } else {
        failMessage = '• ${response?[1]}';
        showOverlaySignIn.value = true;
        showMessageSignIn.value = true;
        return false;
      }
    } else {
      if (user == '') {
        failMessage = '• Pls Enter a Username';
      } else if (user.length < 3 || user.length > 20) {
        failMessage = '• Length of Username Must Between 3 to 20';
      } else if (!(RegExp(r'^[a-zA-Z][a-zA-Z0-9_]+?$').hasMatch(user))) {
        failMessage =
            '• Username Must Start With An Alphabet And Can Only Container Letters, Numbers and \'_\'';
        messageHeightSignIn += 15;
      }
      if (!(RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email))) {
        failMessage = "$failMessage\n• Invalid Email Format";
        messageHeightSignIn += 10;
      }
      if (!(RegExp(r'.{8,}').hasMatch(pass))) {
        failMessage = "$failMessage\n• Password Must be At Least 8 Characters";
        messageHeightSignIn += 10;
      }
      showOverlaySignIn.value = true;
      showMessageSignIn.value = true;
      return false;
    }
  }
}
