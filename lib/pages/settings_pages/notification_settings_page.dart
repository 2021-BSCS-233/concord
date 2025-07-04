import 'package:concord/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/widgets/settings_tile.dart';
import 'package:concord/controllers/settings_controller.dart';

class NotificationSettingsPage extends StatelessWidget {
  final SettingsController settingsController = Get.find<SettingsController>();
  final NotificationSettingsModel modelRef;

  NotificationSettingsPage({super.key, required this.modelRef});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          settingsController.saveSettings();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Notification Settings",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xD0FFFFFF),
                fontSize: 22),
          ),
        ),
        body: GetBuilder(
            init: settingsController,
            id: "notificationSettings",
            builder: (controller) {
              return ListView(
                scrollDirection: Axis.vertical,
                children: [
                  SettingsToggleTile(
                      tileText: 'Notifications',
                      tileIcon: Icons.notifications,
                      toggleValue: modelRef.overallNotif,
                      toggleFunction: (value) {
                        modelRef.overallNotif = value;
                        controller.didChange = true;
                        controller.update(['notificationSettings']);
                      }),
                  SettingsToggleTile(
                      tileText: 'Device Notifications',
                      tileIcon: Icons.notifications_active,
                      toggleValue: modelRef.deviceNotif,
                      toggleFunction: (value) {
                        modelRef.deviceNotif = value;
                        controller.didChange = true;
                        controller.update(['notificationSettings']);
                      }),
                  SettingsToggleTile(
                      tileText: 'App Sound',
                      tileIcon: Icons.notification_important_outlined,
                      toggleValue: modelRef.inAppNotif,
                      toggleFunction: (value) {
                        modelRef.inAppNotif = value;
                        controller.didChange = true;
                        controller.update(['notificationSettings']);
                      }),
                  SettingsToggleTile(
                      tileText: 'Notification Panel',
                      tileIcon: Icons.settings_display,
                      toggleValue: modelRef.inAppNotifPanel,
                      toggleFunction: (value) {
                        modelRef.inAppNotifPanel = value;
                        controller.didChange = true;
                        controller.update(['notificationSettings']);
                      }),
                  SettingsToggleTile(
                      tileText: 'DMs',
                      tileIcon: Icons.chat,
                      toggleValue: modelRef.dmNotif,
                      toggleFunction: (value) {
                        modelRef.dmNotif = value;
                        controller.didChange = true;
                        controller.update(['notificationSettings']);
                      }),
                  Container(
                    margin: const EdgeInsets.all(7),
                    decoration: const BoxDecoration(
                      color: Color(0xFF121218),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        SettingsToggleTile(
                            subTile: true,
                            tileText: 'Posts',
                            tileIcon: Icons.notifications,
                            toggleValue: modelRef.overallPostNotif,
                            toggleFunction: (value) {
                              modelRef.overallPostNotif = value;
                              controller.didChange = true;
                              controller.update(['notificationSettings']);
                            }),
                        Visibility(
                            visible: modelRef.overallPostNotif,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Divider(
                                    thickness: 3,
                                    color: Color(0xFF222222),
                                  ),
                                ),
                                SettingsToggleTile(
                                    subTile: true,
                                    tileText: 'Friend\'s Posts',
                                    tileIcon: Icons.post_add,
                                    toggleValue: modelRef
                                        .postNotifications.friendPostNotif,
                                    toggleFunction: (value) {
                                      modelRef.postNotifications
                                          .friendPostNotif = value;
                                      controller.didChange = true;
                                      controller
                                          .update(['notificationSettings']);
                                    }),
                              ],
                            )),
                      ],
                    ),
                  ),
                  // SettingsToggleTile(
                  //     tileText: 'Posts',
                  //     tileIcon: Icons.notifications,
                  //     toggleValue: modelRef.overallPostNotif,
                  //     toggleFunction: (value) {
                  //       modelRef.overallPostNotif = value;
                  //       controller.didChange = true;
                  //       controller.update(['notificationSettings']);
                  //       debugPrint(
                  //           'here: ${modelRef.postNotifications.friendPostNotif}');
                  //     }),
                  // Visibility(
                  //     visible: modelRef.overallPostNotif,
                  //     child: Container(
                  //       margin: const EdgeInsets.all(7),
                  //       padding: const EdgeInsets.only(left: 10),
                  //       decoration: const BoxDecoration(
                  //         color: Color(0xFF121218),
                  //         borderRadius: BorderRadius.all(Radius.circular(20)),
                  //       ),
                  //       child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             SettingsToggleTile(
                  //                 tileText: 'Friend\'s Posts',
                  //                 tileIcon: Icons.post_add,
                  //                 toggleValue: modelRef
                  //                     .postNotifications.friendPostNotif,
                  //                 toggleFunction: (value) {
                  //                   modelRef.postNotifications.friendPostNotif =
                  //                       value;
                  //                   controller.didChange = true;
                  //                   controller.update(['notificationSettings']);
                  //                 }),
                  //             //TODO: add remaining options
                  //           ]),
                  //     )),
                ],
              );
            }),
      ),
    );
  }
}
