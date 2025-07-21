import 'package:concord/controllers/main_controller.dart';
import 'package:concord/pages/settings_pages/accessibility_settings_page.dart';
import 'package:concord/pages/settings_pages/account_settings_page.dart';
import 'package:concord/pages/settings_pages/language_settings_page.dart';
import 'package:concord/pages/settings_pages/notification_settings_page.dart';
import 'package:concord/pages/settings_pages/preference_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:concord/controllers/settings_controller.dart';
import 'package:concord/widgets/settings_tile.dart';

class SettingsListPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final SettingsController settingsController = Get.find<SettingsController>();

  SettingsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xD0FFFFFF),
              fontSize: 22),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsNavTile(
              page: AccountSettingsPage(),
              tileText: "Account",
              tileIcon: Iconsax.profile_circle),
          SettingsNavTile(
              page: AccessibilitySettingsPage(
                  modelRef: settingsController.userSettings.accessibility),
              tileText: "Accessibility",
              tileIcon: Icons.font_download_outlined),
          SettingsNavTile(
              page: NotificationSettingsPage(
                  modelRef: settingsController.userSettings.notifications),
              tileText: "Notifications",
              tileIcon: Icons.notifications),
          SettingsNavTile(
              page: PreferenceSettingsPage(
                  setRef: settingsController.userSettings.postPreference),
              tileText: "Post Preference",
              tileIcon: Icons.room_preferences),
          SettingsNavTile(
              page: LanguageSettingsPage(),
              tileText: 'language'.tr,
              tileIcon: Icons.language),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7),
            child: InkWell(
              onTap: () async {
                Get.defaultDialog(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 20),
                  titlePadding: const EdgeInsets.only(top: 20),
                  backgroundColor: const Color(0xFF121212),
                  barrierDismissible: true,
                  title: 'Confirm',
                  titleStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'gg_sans',
                      color: Colors.white),
                  middleText: 'Are you sure you want to log out',
                  middleTextStyle: const TextStyle(
                    fontFamily: 'gg_sans',
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  textCancel: "Close",
                  textConfirm: 'Log Out',
                  cancelTextColor: Colors.white,
                  confirmTextColor: Colors.white,
                  buttonColor: const Color.fromARGB(255, 255, 77, 0),
                  onConfirm: () {
                    mainController.logOut();
                  },
                );
              },
              child: Container(
                height: 45,
                width: 140,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    'logout'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}