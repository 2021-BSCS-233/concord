import 'package:concord/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialogBox extends StatelessWidget {
  final SettingsController settingsController;
  final TextEditingController fieldTC;
  final String field1Name;
  final String field2Name;
  final String fieldData;
  final bool hidden;
  final Function saveFunction;
  final bool fieldCheck;
  final Function? checkFunction;

  const CustomDialogBox({
    super.key,
    required this.settingsController,
    required this.fieldTC,
    required this.field1Name,
    required this.field2Name,
    required this.fieldData,
    required this.hidden,
    required this.saveFunction,
    required this.fieldCheck,
    this.checkFunction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        fieldTC.text = hidden ? '' : fieldData;
        settingsController.showValueField1.value = false;
        settingsController.showValueField2.value = false;
        settingsController.passwordTC.clear();
        Get.dialog(Dialog(
          backgroundColor: const Color(0xFF121212),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('NEW USERNAME',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFBDBDBD),
                        fontSize: 12)),
                Obx(() => TextFormField(
                      controller: fieldTC,
                      onChanged: (e) {
                        settingsController.showValueField1.value = false;
                      },
                      decoration: InputDecoration(
                          suffixIcon: fieldCheck
                              ? Obx(() => InkWell(
                                    onTap: () async {
                                      checkFunction!();
                                    },
                                    child: settingsController.checking.value
                                        ? Transform.scale(
                                            scale: 0.4,
                                            child:
                                                const CircularProgressIndicator(
                                              color: Color(0xFFBDBDBD),
                                              strokeWidth: 6,
                                            ),
                                          )
                                        : Icon(
                                            Icons.check_circle,
                                            color: settingsController.field1Bool
                                                ? const Color(0xFF4CAF50)
                                                : const Color(0xFFBDBDBD),
                                          ),
                                  ))
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          // border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: settingsController.showValueField1.value
                                  ? (settingsController.field1Bool
                                      ? const Color(0xFF4CAF50)
                                      : const Color(0xFFF44336))
                                  : const Color(0xFFBDBDBD),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: settingsController.showValueField1.value
                                  ? (settingsController.field1Bool
                                      ? const Color(0xFF4CAF50)
                                      : const Color(0xFFF44336))
                                  : const Color(0xFFBDBDBD),
                            ),
                          )),
                    )),
                const SizedBox(height: 2),
                Obx(() => Visibility(
                      visible: settingsController.showValueField1.value,
                      child: Text(settingsController.field1Message,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: settingsController.field1Bool
                                  ? const Color(0xFF4CAF50)
                                  : const Color(0xFFF44336),
                              fontSize: 12)),
                    )),
                const SizedBox(height: 8),
                Text('passU'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFBDBDBD),
                        fontSize: 12)),
                Obx(() => TextFormField(
                      controller: settingsController.passwordTC,
                      onChanged: (e) {
                        settingsController.showValueField2.value = false;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: settingsController.showValueField2.value
                                ? const Color(0xFFF44336)
                                : const Color(0xFFBDBDBD),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: settingsController.showValueField2.value
                                ? const Color(0xFFF44336)
                                : const Color(0xFFBDBDBD),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 2),
                Obx(() => Visibility(
                      visible: settingsController.showValueField2.value,
                      child: const Text('Incorrect Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF44336),
                              fontSize: 12)),
                    )),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 77, 0),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontFamily: 'gg_sans', fontWeight: FontWeight.w800),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (await saveFunction()) {
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 77, 0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'save'.tr,
                          style: const TextStyle(
                              fontFamily: 'gg_sans',
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
      },
      child: Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: const Color(0xFF9E9E9E)),
        ),
        child: Text(
          hidden ? '************' : fieldData,
          overflow: hidden ? TextOverflow.visible : TextOverflow.fade,
          softWrap: false,
          style: TextStyle(fontSize: hidden ? 28 : 18),
        ),
      ),
    );
  }
}
