import 'package:get/get.dart';
import 'package:concord/models/chats_model.dart';
import 'package:concord/services/firebase_services.dart';

class ChatsController extends GetxController {
  var updateCs = 0.obs;
  bool initial = true;
  List<ChatsModel> chatsData = [];

  getInitialData(currentUserId) async {
    await chatsListener(currentUserId, updateChats);
    chatsData = await getInitialChats(currentUserId);
    initial = false;
  }

  updateChats(ChatsModel updateData, updateType) {
    var index = chatsData.indexWhere((map) => map.id == updateData.id);
    if (updateType == 'modified') {
      chatsData[index].latestMessage = updateData.latestMessage;
      chatsData[index].timeStamp = updateData.timeStamp;
    } else if (updateType == 'added' && index < 0) {
      chatsData.insert(0, updateData);
    }
  }
}
