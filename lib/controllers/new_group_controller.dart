import 'package:concord/controllers/main_controller.dart';
import 'package:concord/models/users_model.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NewGroupController extends GetxController {
  MainController mainController = Get.find<MainController>();
  TextEditingController groupNameTextController = TextEditingController();
  List<UsersModel> friendsData;
  List<bool> markedUsers = [];
  var updateL = 0.obs;

  NewGroupController({required this.friendsData}) {
    markedUsers.addAll(List.generate(friendsData.length, (_) => false));
  }

  createGroup() async {
    List<UsersModel> selectUsers = friendsData
        .where((item) => markedUsers[friendsData.indexOf(item)])
        .toList();
    if (selectUsers.length > 1) {
      List<String> usersId = selectUsers.map((user) => user.id!).toList();
      List<String> usersDisplayName =
          selectUsers.map((user) => user.displayName).toList();
      String groupName = '';
      usersId.add(mainController.currentUserData.id!);
      usersDisplayName.insert(0,mainController.currentUserData.displayName);
      if (groupNameTextController.text.trim() != '') {
        groupName = groupNameTextController.text.trim();
      } else {
        groupName = usersDisplayName.take(3).join(', ') +
            (usersDisplayName.length > 3 ? ', ...' : '');
      }
      await createGroupFirebase(usersId, groupName);
    } else {
      debugPrint('not enough users to create group');
    }
  }
}
