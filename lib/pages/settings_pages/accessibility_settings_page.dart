import 'package:concord/controllers/settings_controller.dart';
import 'package:concord/models/settings_model.dart';
import 'package:concord/widgets/settings_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccessibilitySettingsPage extends StatelessWidget {
  final SettingsController settingsController = Get.find<SettingsController>();
  final AccessibilitySettingsModel modelRef;

  AccessibilitySettingsPage({super.key, required this.modelRef});

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
            "Accessibility Settings",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xD0FFFFFF),
                fontSize: 22),
          ),
        ),
        body: GetBuilder(
            init: settingsController,
            id: 'accessibilitySettings',
            builder: (controller) {
              return ListView(
                scrollDirection: Axis.vertical,
                children: [
                  SettingsToggleTile(
                      tileText: 'Username Colors',
                      tileIcon: CupertinoIcons.color_filter_fill,
                      toggleValue: modelRef.userColors,
                      toggleFunction: (value) {
                        modelRef.userColors = value;
                        controller.didChange = true;
                        controller.update(['accessibilitySettings']);
                      }),
                  SettingsToggleTile(
                      tileText: 'Post Attachments',
                      tileIcon: Icons.image,
                      toggleValue: modelRef.postAtt,
                      toggleFunction: (value) {
                        modelRef.postAtt = value;
                        controller.didChange = true;
                        controller.update(['accessibilitySettings']);
                      }),
                ],
              );
            }),
      ),
    );
  }
}
