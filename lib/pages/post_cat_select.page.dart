import 'package:concord/controllers/new_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/controllers/settings_controller.dart';

class PostCategorySelectionPage extends StatelessWidget {
  final SettingsController settingsController = Get.find<SettingsController>();
  final NewPostController newPostController;
  final Set<String> selectedCats;

  PostCategorySelectionPage(
      {super.key, required this.selectedCats, required this.newPostController});

  @override
  Widget build(BuildContext context) {
    List mapKeys = settingsController.categories.keys.toList();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result){
        if(didPop){
          newPostController.categories = selectedCats.toList();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Select Post Categories",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xD0FFFFFF),
                fontSize: 22),
          ),
        ),
        body: GetBuilder(
            init: settingsController,
            id: 'postCatSelection',
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
                                  value: selectedCats.contains(mapKeys[index1]),
                                  onChanged: (value) {
                                    if (value!) {
                                      selectedCats.add(mapKeys[index1]);
                                    } else {
                                      selectedCats.remove(mapKeys[index1]);
                                      selectedCats.removeAll(
                                          controller.categories[mapKeys[index1]]
                                              as Iterable<Object?>);
                                    }
                                    controller.update(['postCatSelection']);
                                  }),
                            ],
                          ),
                          Visibility(
                              visible: (selectedCats.contains(mapKeys[index1])) &&
                                  controller
                                      .categories[mapKeys[index1]]!.isNotEmpty,
                              child: const Divider(
                                thickness: 3,
                                color: Color(0xFF222222),
                              )),
                          Visibility(
                            visible: selectedCats.contains(mapKeys[index1]),
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
                                      Text(controller
                                          .categories[mapKeys[index1]]![index2]),
                                      Checkbox(
                                          value: selectedCats.contains(controller
                                                  .categories[mapKeys[index1]]
                                              ?[index2]),
                                          onChanged: (value) {
                                            if (value!) {
                                              selectedCats.add(
                                                  controller.categories[
                                                      mapKeys[index1]]![index2]);
                                            } else {
                                              selectedCats.remove(
                                                  controller.categories[
                                                      mapKeys[index1]]![index2]);
                                            }
                                            controller
                                                .update(['postCatSelection']);
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
