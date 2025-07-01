import 'package:concord/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/models/request_model.dart';
import 'package:concord/services/firebase_services.dart';

class RequestsController extends GetxController {
  final MainController mainController = Get.find<MainController>();
  final MyFirestore myFirestore = MyFirestore();
  var initial = true;
  List<RequestsModel> incomingRequestsData = [];
  List<RequestsModel> outgoingRequestsData = [];
  var fieldCheck = false.obs;
  TextEditingController requestsFieldTextController = TextEditingController();

  void changing() {
    fieldCheck.value = (requestsFieldTextController.text != '' ? true : false);
  }

  getInitialData(currentUserId) async {
    var result = await myFirestore.getInitialRequestFirebase(currentUserId);
    mainController.requestListenerRef ??=
        myFirestore.requestsListenersFirebase(currentUserId, updateRequests);
    incomingRequestsData = result[0];
    outgoingRequestsData = result[1];
    initial = false;
  }

  Future<void> sendRequest() async {
    fieldCheck.value = false;
    var response = await myFirestore.sendRequestFirebase(
        mainController.currentUserData,
        requestsFieldTextController.text.trim().toLowerCase());
    requestsFieldTextController.text = '';
    if (response != 'Request Sent') {
      errorMessage(response);
    }
  }

  inRequestAction(index, action) {
    myFirestore.requestActionFirebase(incomingRequestsData[index].id!, action);
  }
  outRequestAction(index, action) {
    myFirestore.requestActionFirebase(outgoingRequestsData[index].id!, action);
  }

  updateRequests(RequestsModel updateData, updateType, sender) {
    if (sender) {
      var index =
          outgoingRequestsData.indexWhere((map) => map.id == updateData.id);
      if (updateType == 'added' && index < 0) {
        outgoingRequestsData.insert(0, updateData);
      } else if (updateType == 'removed') {
        outgoingRequestsData.removeAt(index);
      }
      update(['ORSection']);
    } else {
      var index =
          incomingRequestsData.indexWhere((map) => map.id == updateData.id);
      if (updateType == 'added' && index < 0) {
        incomingRequestsData.insert(0, updateData);
      } else if (updateType == 'removed') {
        incomingRequestsData.removeAt(index);
      }
      update(['IRSection']);
    }
  }

  errorMessage(String text) {
    Get.defaultDialog(
      contentPadding:
          const EdgeInsetsGeometry.symmetric(horizontal: 30, vertical: 20),
      titlePadding: const EdgeInsetsGeometry.only(top: 10),
      backgroundColor: const Color(0xFF121212),
      barrierDismissible: false,
      title: 'Alert',
      titleStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: 'gg_sans',
          color: Colors.white),
      middleText: text,
      middleTextStyle: const TextStyle(
        fontFamily: 'gg_sans',
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      textCancel: "Close",
      cancelTextColor: Colors.white,
      confirmTextColor: Colors.white,
      buttonColor: const Color.fromARGB(255, 255, 77, 0),
    );
  }
}
