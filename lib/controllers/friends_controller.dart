import 'package:concord/controllers/main_controller.dart';
import 'package:concord/models/users_model.dart';
import 'package:get/get.dart';
import 'package:concord/services/firebase_services.dart';

class FriendsController extends GetxController {
  MainController mainController = Get.find<MainController>();
  bool initial = true;
  var updateF = 0.obs;
  List<UsersModel> friendsData = [];

  getInitialData(currentUserId) async {
    friendsData = await getInitialFriendsFirebase(currentUserId);
    mainController.friendsListenerRef =
        friendsListenerFirebase(currentUserId, updateFriends);
    initial = false;
  }

  updateFriends(UsersModel updateData, updateType) {
    var index = friendsData.indexWhere((map) => map.id == updateData.id);
    if (updateType == 'modified') {
      friendsData[index] = updateData;
    } else if (updateType == 'added' && index < 0) {
      friendsData.insert(0, updateData);
    } else if (updateType == 'removed') {
      friendsData.removeAt(index);
    }
    updateF.value += 1;
  }
}
