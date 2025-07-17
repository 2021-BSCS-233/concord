import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/settings_model.dart';
import '../models/users_model.dart';
import '../services/services.dart';
import 'main_controller.dart';

class AuthController extends GetxController {
  final user = Rxn<User>();
  final MyAuthentication myAuthentication = MyAuthentication();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(FirebaseAuth.instance.authStateChanges());

    ever(user, _handleAuthStateChanges);
  }

  void _handleAuthStateChanges(User? firebaseUser) async {
    final mainController = Get.find<MainController>();

    if (firebaseUser != null) {
      mainController.isUserDataLoading.value = true;
      String userId = firebaseUser.uid;

      try {
        var userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        var settingsData = await FirebaseFirestore.instance.collection('settings').doc(userId).get();
        SettingsModel userSettings;
        if (!settingsData.exists) {
          userSettings = SettingsModel.defaultSettings();
          userSettings.docRef = FirebaseFirestore.instance.collection('settings').doc(userId);
          await userSettings.docRef!.set(userSettings.toJson());
        } else {
          userSettings =
              SettingsModel.fromJson(settingsData.data() as Map<String, dynamic>);
          userSettings.docRef = settingsData.reference;
        }

        mainController.currentUserData =
            UsersModel.fromJson(userData.data() as Map<String, dynamic>);
        mainController.currentUserData.id = userId;
        mainController.currentUserData.docRef = userData.reference;
        mainController.mySocket = MySocket();
        mainController.userSettings = userSettings;
        mainController.isUserDataLoading.value = false;

        mainController.mySocket!.connectSocket(userId);
      } catch (e) {
        debugPrint("Error fetching user data: $e");
        FirebaseAuth.instance.signOut();
        mainController.isUserDataLoading.value = false;
      }
    } else {
      mainController.isUserDataLoading.value = false;
    }
  }
}