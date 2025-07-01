import 'package:concord/controllers/language_controller.dart';
import 'package:concord/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageSettingsPage extends StatelessWidget {
  final SettingsController settingsController = Get.find<SettingsController>();
  final LocalizationController localizationController =
      Get.find<LocalizationController>();
  final Map languageIndex = {
    'en': 1,
    'es': 2,
  };

  LanguageSettingsPage({super.key}) {
    settingsController.selectedLang.value = languageIndex['en'];
  }

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
            "Language Settings",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xD0FFFFFF),
                fontSize: 22),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(7),
          decoration: const BoxDecoration(
            color: Color(0xFF121218),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Obx(() => Column(
                children: [
                  ListTile(
                    title: const Text('English'),
                    trailing: Radio(
                        value: 1,
                        groupValue: settingsController.selectedLang.value,
                        onChanged: (value) async {
                          settingsController.selectedLang.value = value!;
                          settingsController.userSettings.language = 'en';
                          localizationController.setLocal('en');
                          settingsController.didChange = true;
                        }),
                  ),
                  ListTile(
                    title: const Text('Spanish'),
                    trailing: Radio(
                        value: 2,
                        groupValue: settingsController.selectedLang.value,
                        onChanged: (value) async {
                          settingsController.selectedLang.value = value!;
                          settingsController.userSettings.language = 'es';
                          localizationController.setLocal('es');
                          settingsController.didChange = true;
                        }),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
