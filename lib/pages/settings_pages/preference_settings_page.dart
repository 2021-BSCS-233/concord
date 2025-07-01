import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/controllers/settings_controller.dart';

class PreferenceSettingsPage extends StatelessWidget {
  final SettingsController settingsController = Get.find<SettingsController>();
  PreferenceSettingsPage({super.key});

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
            "Preference Settings",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xD0FFFFFF),
                fontSize: 22),
          ),
        ),
        body: Container(),
      ),
    );
  }
}
