import 'package:concord/controllers/main_controller.dart';
import 'package:concord/pages/settings_pages/accessibility_settings_page.dart';
import 'package:concord/pages/settings_pages/account_settings_page.dart';
import 'package:concord/pages/settings_pages/notification_settings_page.dart';
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
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsNavTile(
              page: AccountSettingsPage(),
              tileText: "Account settings",
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
              page: Container(),
              tileText: "Language",
              tileIcon: Icons.language),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7),
            child: InkWell(
              onTap: () async {
                Get.defaultDialog(
                  contentPadding:
                  const EdgeInsetsGeometry.symmetric(
                      horizontal: 30, vertical: 20),
                  titlePadding: const EdgeInsetsGeometry.only(top: 20),
                  backgroundColor: const Color(0xFF121212),
                  barrierDismissible: false,
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

// import 'package:concord/pages/account_settings_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
//
// class SettingsListPage extends StatelessWidget{
//   const SettingsListPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Setting"),
//       ),
//       body: ListView(
//         children: [
//           Column(children: [
//             Container(
//               margin: const EdgeInsets.all(4),
//               decoration: const BoxDecoration(
//                 color: Color(0xFF121218),
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//               ),
//               child: InkWell(
//                 onTap: () {
//                   Get.to(AccountSettingsPage());
//                 },
//                 child: const ListTile(
//                   leading: Text(
//                     "Profile settings",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   trailing: Icon(Iconsax.profile_circle),
//                 ),
//               ),
//             ),
//           ]),
//         ],
//       ),
//     );
//   }
// }
