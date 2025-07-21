import 'package:concord/widgets/custom_dialog_box.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:concord/controllers/language_controller.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/controllers/settings_controller.dart';

class AccountSettingsPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final SettingsController settingsController = Get.find<SettingsController>();
  final LocalizationController localizationController =
      Get.find<LocalizationController>();

  AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'accountSetting'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          body: GetBuilder(
              init: settingsController,
              id: 'accountPage',
              builder: (controller) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text('usernameU'.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade400,
                                fontSize: 12)),
                        CustomDialogBox(
                          fieldTC: controller.usernameTC,
                          settingsController: controller,
                          field1Name: 'NEW USERNAME',
                          field2Name: 'passU'.tr,
                          fieldData: mainController.currentUserData.username,
                          hidden: false,
                          fieldCheck: true,
                          checkFunction: () {
                            controller.checkUsernameAvailability();
                          },
                          saveFunction: () async {
                            return await controller.changeUsername();
                          },
                        ),
                        const SizedBox(height: 10),
                        Text('emailU'.tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFBDBDBD),
                                fontSize: 12)),
                        CustomDialogBox(
                          fieldTC: controller.emailTC,
                          settingsController: controller,
                          field1Name: 'NEW EMAIL',
                          field2Name: 'passU'.tr,
                          fieldData: mainController.currentUserData.email,
                          hidden: false,
                          fieldCheck: false,
                          saveFunction: () {},
                        ),
                        const SizedBox(height: 10),
                        Text('passU'.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade400,
                                fontSize: 12)),
                        CustomDialogBox(
                          fieldTC: controller.newPassTC,
                          settingsController: controller,
                          field1Name: 'newPassU'.tr,
                          field2Name: 'oldPassU'.tr,
                          fieldData: '',
                          hidden: true,
                          fieldCheck: false,
                          saveFunction: () async {
                            return await controller.changePass();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
