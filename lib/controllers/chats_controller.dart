import 'package:concord/controllers/main_controller.dart';
import 'package:get/get.dart';
import 'package:concord/models/chats_model.dart';
import 'package:concord/services/firebase_services.dart';

class ChatsController extends GetxController {
  MainController mainController = Get.find<MainController>();
  bool initial = true;
  List<ChatsModel> chatsData = [];

  getInitialData(currentUserId) async {
    chatsData = await getInitialChatsFirebase(currentUserId);
    mainController.chatsListenerRef =
        chatsListenerFirebase(currentUserId, updateChats);
    initial = false;
  }

  updateChats(ChatsModel updateData, updateType) {
    var index = chatsData.indexWhere((map) => map.id == updateData.id);
    if (updateType == 'added' && index < 0) {
      chatsData.insert(0, updateData);
    } else if (updateType == 'modified' && !(index < 0)) {
      chatsData[index].latestMessage = updateData.latestMessage;
      chatsData[index].timeStamp = updateData.timeStamp;
      chatsData.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
    } else if (updateType == 'removed' && !(index < 0)) {
      chatsData.removeAt(index);
      if(mainController.selectedChatId == updateData.id){
        mainController.showMenu.value = false;
      }
    }
    update(['chatsSection']);
  }
}
