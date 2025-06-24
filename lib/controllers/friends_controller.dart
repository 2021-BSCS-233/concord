import 'package:concord/controllers/main_controller.dart';
import 'package:concord/models/chats_model.dart';
import 'package:concord/models/users_model.dart';
import 'package:get/get.dart';
import 'package:concord/services/firebase_services.dart';

class FriendsController extends GetxController {
  final MainController mainController = Get.find<MainController>();
  final MyFirestore myFirestore = MyFirestore();
  bool initial = true;
  List<UsersModel> friendsData = [];

  Future<void> getInitialData(currentUserId) async {
    friendsData = await myFirestore.getInitialFriendsFirebase(currentUserId);
    mainController.friendsListenerRef =
        myFirestore.friendsListenerFirebase(currentUserId, updateFriends);
    initial = false;
  }

  Future<ChatsModel> getUserChat(index) async {
    return await myFirestore.getUserChatFirebase(
        mainController.currentUserData.id!, friendsData[index].id!);
  }

  removeFriend(index) {
    myFirestore.removeFriendFirebase(
        mainController.currentUserData.id!, friendsData[index].id!);
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
    update(['friendsSection']);
  }
}
