import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:concord/controllers/language_controller.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final SettingsController editSettingsController =
      Get.put(SettingsController());
  final LocalizationController localizationController =
      Get.find<LocalizationController>();

  SettingsPage({super.key}) {
    editSettingsController.usernameTextController.text =
        mainController.currentUserData.username;
    editSettingsController.emailTextController.text =
        mainController.currentUserData.email;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'accountSetting'.tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text('usernameU'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            fontSize: 12)),
                    TextFormField(
                      controller: editSettingsController.usernameTextController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: const OutlineInputBorder(),
                        labelText:
                            mainController.currentUserData.displayName,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('emailU'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            fontSize: 12)),
                    TextFormField(
                      controller: editSettingsController.emailTextController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: const OutlineInputBorder(),
                        labelText: mainController.currentUserData.email,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            editSettingsController.toggleMenu();
                          },
                          child: Container(
                            height: 45,
                            width: 140,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent.shade700,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text(
                                'changePass'.tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // update
                          },
                          child: Container(
                            height: 45,
                            width: 140,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent.shade700,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Center(
                              child: Text(
                                'save'.tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('language'.tr,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                        fontSize: 14)),
                DropdownButton(
                    value: localizationController.prefs.getString('locale') ??
                        'en',
                    items: const [
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: 'es',
                        child: Text('Spanish'),
                      )
                    ],
                    onChanged: (value) {
                      localizationController.setLocal(value);
                    }),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    mainController.logOut();
                  },
                  child: Container(
                    height: 45,
                    width: 140,
                    decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        'logout'.tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: editSettingsController.showMenu.value,
              child: GestureDetector(
                onTap: () {
                  editSettingsController.toggleMenu();
                },
                child: Container(
                  color: const Color(0xC01D1D1F),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                ),
              ),
            )),
        Obx(() => Material(
              color: Colors.transparent,
              child: Visibility(
                visible: editSettingsController.showMenu.value,
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      height: 400,
                      width: 300,
                      decoration: const BoxDecoration(
                          color: Color(0xFF121218),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('oldPassU'.tr,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                  fontSize: 12)),
                          TextFormField(
                            controller:
                                editSettingsController.passwordTextController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text('oldPassU'.tr,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                  fontSize: 12)),
                          TextFormField(
                            controller:
                                editSettingsController.passwordTextController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
