// posts created by you
// each user has a separate list of notifications
// combined collection of notifications
// notification for multiple users to avoid creating notification duplication per user
// posts followed/enabled notifications for
// post potentially storing notification info locally
// sub collection for this local info

//ability to redirect to where post was generated

import 'package:concord/controllers/main_controller.dart';
import 'package:concord/models/notifications_model.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  MainController mainController = Get.find<MainController>();
  List<NotificationsModel> notificationContent = [];
  bool initial = true;

  getInitialData(currentUserId) async {
    notificationContent = await getNotificationsFirebase(currentUserId);
    mainController.notificationListenerRef =
        notificationsListenerFirebase(currentUserId, updateNotifications);
    initial = false;
  }

  updateNotifications(NotificationsModel updateData, updateType) {
    var index =
        notificationContent.indexWhere((map) => map.id == updateData.id);
    if (updateType == 'added' && index < 0) {
      notificationContent.insert(0, updateData);
    } else if (updateType == 'modified' && !(index < 0)) {
      debugPrint('working on modifications');
    } else if (updateType == 'removed' && !(index < 0)) {
      notificationContent.removeAt(index);
    }
    update(['chatSection']);
  }
}
