import 'package:concord/pages/account_settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:concord/controllers/settings_controller.dart';
import 'package:concord/widgets/settings_tile.dart';

class SettingsListPage extends StatelessWidget {
  const SettingsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController =
        Get.find<SettingsController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          SettingsNavTile(
              page: AccountSettingsPage(),
              tileText: "Account settings",
              tileIcon: Iconsax.profile_circle),
          SettingsNavTile(
              page: Container(),
              tileText: "Accessibility",
              tileIcon: Icons.font_download_outlined),
          SettingsNavTile(
              page: Container(),
              tileText: "Language",
              tileIcon: Icons.language),
          SettingsNavTile(
              page: Container(),
              tileText: "Notifications",
              tileIcon: CupertinoIcons.bell_fill),
          // Container(
          //   margin: const EdgeInsets.all(7),
          //   padding: const EdgeInsets.all(5),
          //   decoration: const BoxDecoration(
          //     color: Color(0xFF121218),
          //     borderRadius: BorderRadius.all(Radius.circular(20)),
          //   ),
          //   child: InkWell(
          //     onTap: () {
          //       Get.to(AccountSettingsPage());
          //     },
          //     child: const ListTile(
          //       leading: Icon(
          //         Iconsax.profile_circle,
          //         color: Colors.white,
          //       ),
          //       title: Text(
          //         "Account settings",
          //         style: TextStyle(fontSize: 18, color: Colors.white),
          //       ),
          //       trailing: Icon(
          //         Iconsax.arrow_right_1_copy,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          // Container(
          //   margin: const EdgeInsets.all(7),
          //   padding: const EdgeInsets.all(5),
          //   decoration: const BoxDecoration(
          //     color: Color(0xFF121218),
          //     borderRadius: BorderRadius.all(Radius.circular(20)),
          //   ),
          //   child: Obx(
          //     () => ListTile(
          //       leading: const Icon(
          //         Icons.language, // Globe icon
          //         color: Colors.white,
          //         size: 24.0,
          //       ),
          //       title: const Text(
          //         'Vibration',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 18.0,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //       trailing: Switch(
          //         value: settingsController.isVibrationEnabled.value,
          //         onChanged: settingsController.toggleVibration,
          //         activeColor: Colors.blue,
          //         inactiveThumbColor: Colors.grey,
          //         inactiveTrackColor: Colors.grey[700],
          //       ),
          //       onTap: () {
          //         settingsController.toggleVibration(
          //             !settingsController.isVibrationEnabled.value);
          //       },
          //     ),
          //   ),
          // ),
          // Container(
          //   margin: const EdgeInsets.all(7),
          //   padding: EdgeInsets.all(5),
          //   decoration: const BoxDecoration(
          //     color: Color(0xFF121218),
          //     borderRadius: BorderRadius.all(Radius.circular(20)),
          //   ),
          //   child: Obx(
          //     () => ListTile(
          //       leading: const Icon(
          //         Icons.notifications_none, // Globe icon
          //         color: Colors.white,
          //         size: 24.0,
          //       ),
          //       title: const Text(
          //         'Notifications',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 18.0,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //       trailing: Switch(
          //         value: settingsController.isNotificationEnabled.value,
          //         onChanged: settingsController.toggleNotification,
          //         activeColor: Colors.blue,
          //         inactiveThumbColor: Colors.grey,
          //         inactiveTrackColor: Colors.grey[700],
          //       ),
          //       onTap: () {
          //         settingsController.toggleNotification(
          //             !settingsController.isNotificationEnabled.value);
          //       },
          //     ),
          //   ),
          // ),
          // Container(
          //   margin: const EdgeInsets.all(7),
          //   padding: EdgeInsets.all(5),
          //   decoration: const BoxDecoration(
          //     color: Color(0xFF121218),
          //     borderRadius: BorderRadius.all(Radius.circular(20)),
          //   ),
          //   child: Obx(
          //     () => ListTile(
          //       leading: const Icon(
          //         Icons.color_lens, // Globe icon
          //         color: Colors.white,
          //         size: 24.0,
          //       ),
          //       title: const Text(
          //         'Light Theme',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 18.0,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //       trailing: Switch(
          //         value: settingsController.isLightThemeEnabled.value,
          //         onChanged: settingsController.toggleLightTheme,
          //         activeColor: Colors.blue,
          //         inactiveThumbColor: Colors.grey,
          //         inactiveTrackColor: Colors.grey[700],
          //       ),
          //       onTap: () {
          //         settingsController.toggleLightTheme(
          //             !settingsController.isLightThemeEnabled.value);
          //       },
          //     ),
          //   ),
          // ),
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
