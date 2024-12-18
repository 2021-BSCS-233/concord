import 'package:concord/controllers/main_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:concord/models/request_model.dart';
import 'package:concord/services/firebase_services.dart';

class RequestsController extends GetxController {
  MainController mainController = Get.find<MainController>();
  var initial = true;
  List<RequestsModel> incomingRequestsData = [];
  List<RequestsModel> outgoingRequestsData = [];
  var fieldCheck = false.obs;
  TextEditingController requestsFieldTextController = TextEditingController();

  void changing() {
    fieldCheck.value = (requestsFieldTextController.text != '' ? true : false);
  }

  getInitialData(currentUserId) async {
    var result = await getInitialRequestFirebase(currentUserId);
    mainController.requestListenerRef =
        requestsListenersFirebase(currentUserId);
    incomingRequestsData = result[0];
    outgoingRequestsData = result[1];
    initial = false;
  }

  updateIncomingRequests(RequestsModel updateData, updateType) {
    var index =
        incomingRequestsData.indexWhere((map) => map.id == updateData.id);
    if (updateType == 'added' && index < 0) {
      incomingRequestsData.insert(0, updateData);
    } else if (updateType == 'removed') {
      incomingRequestsData.removeAt(index);
    }
    update(['IRSection']);
  }

  updateOutgoingRequests(RequestsModel updateData, updateType) {
    var index =
        outgoingRequestsData.indexWhere((map) => map.id == updateData.id);
    if (updateType == 'added' && index < 0) {
      outgoingRequestsData.insert(0, updateData);
    } else if (updateType == 'removed') {
      outgoingRequestsData.removeAt(index);
    }
    update(['ORSection']);
  }
}
