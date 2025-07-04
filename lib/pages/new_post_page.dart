import 'package:concord/controllers/main_controller.dart';
import 'package:concord/controllers/new_post_controller.dart';
import 'package:concord/pages/post_cat_select.page.dart';
import 'package:concord/widgets/input_field.dart';
import 'package:concord/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPostPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final NewPostController newPostController = Get.put(NewPostController());

  NewPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'New Post',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xD0FFFFFF),
                  fontSize: 22),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Text(
                      'Title:',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  // const SizedBox(height: 5),

                  CustomInputField(
                      fieldColor: const Color(0xFF121218),
                      fieldLabel: '',
                      fieldRadius: 20,
                      maxLines: 3,
                      maxLength: 90,
                      contentBottomPadding: 6.5,
                      controller: newPostController.titleTextController),
                  const Padding(
                    padding: EdgeInsets.only(top: 8, left: 6),
                    child: Text(
                      'Description:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  CustomInputField(
                      fieldColor: const Color(0xFF121218),
                      fieldLabel: '',
                      fieldRadius: 20,
                      minLines: 8,
                      maxLines: 15,
                      maxLength: 900,
                      contentBottomPadding: 6.5,
                      controller: newPostController.descriptionTextController),
                  const SizedBox(height: 10),
                  Obx(() => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF121218),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            SettingsToggleTile(
                                subTile: true,
                                tileText: 'Auto Categorization',
                                tileIcon: Icons.auto_awesome_sharp,
                                toggleValue: newPostController.autoCat.value,
                                toggleFunction: (value) {
                                  newPostController.autoCat.value = value;
                                }),
                            Visibility(
                                visible: !newPostController.autoCat.value,
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: Divider(
                                        thickness: 3,
                                        color: Color(0xFF222222),
                                      ),
                                    ),
                                    SettingsNavTile(
                                      subTile: true,
                                      page: PostCategorySelectionPage(
                                        selectedCats:
                                            newPostController.categories.toSet(),
                                        newPostController: newPostController,
                                      ),
                                      tileIcon: Icons.room_preferences,
                                      tileText: 'Select Categories',
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                        onPressed: () async {
                          bool result = await newPostController
                              .sendPost(mainController.currentUserData.id);
                          if (result) {
                            Get.delete<NewPostController>();
                            Get.back();
                          } else {
                            debugPrint('Error occurred with auto classification');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 77, 0),
                        ),
                        child: const Text(
                          "Create post",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
        Obx(() => Visibility(
          visible: newPostController.showWaitOverlay.value,
          child: Container(
            color: const Color(0xC01D1D1F),
            child: const Center(child: CircularProgressIndicator()),
          ),
        )),
      ],
    );
  }
}
