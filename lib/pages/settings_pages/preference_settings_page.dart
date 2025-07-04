import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/controllers/settings_controller.dart';

class PreferenceSettingsPage extends StatelessWidget {
  final SettingsController settingsController = Get.find<SettingsController>();
  final Set<String> setRef;

  PreferenceSettingsPage({super.key, required this.setRef});

  @override
  Widget build(BuildContext context) {
    List mapKeys = settingsController.categories.keys.toList();
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
        body: GetBuilder(
            init: settingsController,
            id: 'preferenceSettings',
            builder: (controller) {
              return ListView.builder(
                  itemCount: mapKeys.length,
                  itemBuilder: (context, index1) {
                    return Container(
                      margin: const EdgeInsets.all(7),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: const BoxDecoration(
                        color: Color(0xFF121218),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(mapKeys[index1]),
                              Checkbox(
                                  value: setRef.contains(mapKeys[index1]) ||
                                      controller.categories[mapKeys[index1]]!
                                          .any((value) {
                                        return setRef.contains(value);
                                      }),
                                  onChanged: (value) {
                                    if (value!) {
                                      setRef.add(mapKeys[index1]);
                                    } else {
                                      setRef.remove(mapKeys[index1]);
                                      setRef.removeAll(
                                          controller.categories[mapKeys[index1]]
                                              as Iterable<Object?>);
                                    }
                                    controller.didChange = true;
                                    controller.update(['preferenceSettings']);
                                  }),
                            ],
                          ),
                          Visibility(
                              visible: (setRef.contains(mapKeys[index1]) ||
                                      controller.categories[mapKeys[index1]]!
                                          .any((value) {
                                        return setRef.contains(value);
                                      })) &&
                                  controller
                                      .categories[mapKeys[index1]]!.isNotEmpty,
                              child: const Divider(
                                thickness: 3,
                                color: Color(0xFF222222),
                              )),
                          Visibility(
                            visible: setRef.contains(mapKeys[index1]) ||
                                controller.categories[mapKeys[index1]]!
                                    .any((value) {
                                  return setRef.contains(value);
                                }),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller
                                    .categories[mapKeys[index1]]?.length,
                                itemBuilder: (context, index2) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(controller.categories[
                                          mapKeys[index1]]![index2]),
                                      Checkbox(
                                          value: setRef.contains(controller
                                                  .categories[mapKeys[index1]]
                                              ?[index2]),
                                          onChanged: (value) {
                                            if (value!) {
                                              setRef.add(controller.categories[
                                                  mapKeys[index1]]![index2]);
                                              setRef.remove(mapKeys[index1]);
                                            } else {
                                              setRef.remove(controller
                                                      .categories[
                                                  mapKeys[index1]]![index2]);
                                              if (!(controller
                                                  .categories[mapKeys[index1]]!
                                                  .any((value) {
                                                return setRef.contains(value);
                                              }))) {
                                                setRef.add(mapKeys[index1]);
                                              }
                                            }
                                            controller.didChange = true;
                                            controller
                                                .update(['preferenceSettings']);
                                          }),
                                    ],
                                  );
                                }),
                          )
                        ],
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
