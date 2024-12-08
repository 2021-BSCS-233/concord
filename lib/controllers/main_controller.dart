import 'package:concord/models/users_model.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  late UsersModel currentUserData;
  var updateM = 0.obs;
  var showMenu = false.obs;
  var showProfile = false.obs;
  var selectedIndex = 0.obs;
  var selectedId = '';
  var selectedUsername = '';
  var selectedUserPic = '';
  var selectedChatType = '';

  // MainController({required this.currentUserData});

  void toggleMenu(dataList) {
    selectedId = dataList[0];
    selectedUsername = dataList[1];
    selectedUserPic = dataList[2];
    selectedChatType = dataList[3];
    showMenu.value = !showMenu.value;
  }

  void toggleProfile(data) {
    selectedId = data;
    showProfile.value = !showProfile.value;
  }
}
