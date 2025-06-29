import 'package:concord/pages/settings_list_page.dart';
import 'package:concord/widgets/profile_picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/pages/edit_profile_page.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/widgets/status_icons.dart';

class ProfilePage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          //TODO: not rebuild the whole page... Lazy
          child: GetBuilder(
              init: mainController,
              id: 'profileSection',
              builder: (controller) {
                return Column(
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            mainController.currentUserData.bannerImg == ''
                                ? Container(
                                    width: double.infinity,
                                    height: 150,
                                    color: Color(mainController
                                        .currentUserData.bannerColor),
                                  )
                                : Container(),
                            Container(
                              width: double.infinity,
                              height: 50,
                              color: Colors.transparent,
                            )
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          left: 20,
                          child: Stack(
                            children: [
                              Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 6)),
                                child: ProfilePicture(
                                    profileLink: mainController
                                        .currentUserData.profilePicture),
                              ),
                              Positioned(
                                bottom: 3,
                                right: 3,
                                child: StatusIcon(
                                  iconType: mainController
                                      .currentUserData.displayStatus,
                                  iconSize: 24,
                                  iconBorder: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            right: 15,
                            top: 40,
                            child: InkWell(
                              onTap: () {
                                Get.to(const SettingsListPage());
                              },
                              child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black54),
                                  child: const Icon(
                                    Icons.settings,
                                    size: 28,
                                  )),
                            ))
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 18),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      height: 168,
                      decoration: const BoxDecoration(
                          color: Color(0xFF121218),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mainController.currentUserData.displayName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            mainController.currentUserData.username,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            mainController.currentUserData.pronouns,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    mainController.toggleStatus();
                                  },
                                  child: Container(
                                      height: 38,
                                      width: 140,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 255, 77, 0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.chat_bubble_fill,
                                            size: 20,
                                          ),
                                          Text(
                                            'editStatus'.tr,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(EditProfilePage());
                                  },
                                  child: Container(
                                    height: 38,
                                    width: 140,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 255, 77, 0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.edit,
                                          size: 20,
                                        ),
                                        Text(
                                          'editProfile'.tr,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      // height: 200,
                      decoration: const BoxDecoration(
                          color: Color(0xFF121218),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'aboutMe'.tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              child: Text(
                                mainController.currentUserData.aboutMe,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey.shade300),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              })),
    );
  }
}
