import 'package:concord/pages/account_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SettingsListPage extends StatelessWidget{
  const SettingsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: ListView(
        children: [
          Column(children: [
            Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF121218),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: InkWell(
                onTap: () {
                  Get.to(AccountSettingsPage());
                },
                child: const ListTile(
                  leading: Text(
                    "Profile settings",
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: Icon(Iconsax.profile_circle),
                ),
              ),
            ),
          ]),
        ],
      ),
      // body: ListView.builder(
      //     itemCount: 1,
      //     itemBuilder: (context, index) {
      //       return Column(children: [
      //         Container(
      //           margin: const EdgeInsets.all(4),
      //           decoration: const BoxDecoration(
      //             color: Color(0xFF121218),
      //             borderRadius: BorderRadius.all(Radius.circular(20)),
      //           ),
      //           child: InkWell(
      //             onTap: () {
      //               Get.to(AccountSettingsPage());
      //             },
      //             child: const ListTile(
      //               leading: Text(
      //                 "Profile settings",
      //                 style: TextStyle(fontSize: 16),
      //               ),
      //               trailing: Icon(Iconsax.profile_circle),
      //             ),
      //           ),
      //         ),
      //       ]);
      //     }),
    );
  }
}
