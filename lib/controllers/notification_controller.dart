//TODO: Figure out what to notify for

// posts created by you
// each user has a separate list of notifications
// combined collection of notifications
// notification for multiple users to avoid creating notification duplication per user
// posts followed/enabled notifications for
// post potentially storing notification info locally
// sub collection for this local info

//ability to redirect to where post was generated

import 'package:concord/models/notifications_model.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController{
  List<NotificationsModel> notificationContent = [];


}