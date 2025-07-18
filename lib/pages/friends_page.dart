import 'package:concord/models/chats_model.dart';
import 'package:concord/pages/chat_page.dart';
import 'package:concord/widgets/custom_loading_logo.dart';
import 'package:concord/widgets/profile_picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/pages/requests_page.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/controllers/friends_controller.dart';

class FriendsPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final FriendsController friendsController = Get.find<FriendsController>();

  FriendsPage({super.key}) {
    friendsController.initial = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'friends'.tr,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xD0FFFFFF),
              fontSize: 22),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => RequestsPage());
            },
            child: Container(
              height: 40,
              width: 130,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 77, 0),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_add),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('addFriend'.tr),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: FutureBuilder<Widget>(
        future: friendsUI(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else if (snapshot.hasError) {
            debugPrint('${snapshot.error}');
            return const Material(
                color: Colors.transparent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("We could not access our services"),
                      Text("Check your connection or try again later")
                    ],
                  ),
                ));
          }
          return const CustomLoadingLogo();
        },
      ),
    );
  }

  Future<Widget> friendsUI() async {
    return GetBuilder(
        init: friendsController,
        id: 'friendsSection',
        builder: (controller) {
          return controller.friendsData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'friendsEmpty'.tr,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ListView.builder(
                      itemCount: controller.friendsData.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 15),
                          decoration: const BoxDecoration(
                            color: Color(0xFF121218),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: ListTile(
                            leading: InkWell(
                              onTap: () {
                                mainController.toggleProfile(
                                    controller.friendsData[index].id);
                              },
                              child: ProfilePicture(
                                profileLink: controller
                                    .friendsData[index].profilePicture,
                                profileRadius: 20,
                              ),
                            ),
                            title: Text(
                              controller.friendsData[index].displayName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: SizedBox(
                              width: 70,
                              child: Row(
                                children: [
                                  InkWell(
                                    enableFeedback: true,
                                    child: const Icon(
                                        CupertinoIcons.chat_bubble_text_fill),
                                    onTap: () async {
                                      ChatsModel chatData =
                                          await friendsController
                                              .getUserChat(index);
                                      Get.to(() => ChatPage(chatData: chatData));
                                    },
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                      enableFeedback: true,
                                      child: const Icon(
                                        Icons.person_remove,
                                        color: Colors.red,
                                      ),
                                      // onTap: () {
                                      //   friendsController.removeFriend(index);
                                      // },
                                      onTap: () {
                                        Get.defaultDialog(
                                            contentPadding:
                                                const EdgeInsetsGeometry
                                                    .symmetric(
                                                    horizontal: 30,
                                                    vertical: 20),
                                            titlePadding:
                                                const EdgeInsetsGeometry.only(
                                                    top: 10),
                                            backgroundColor:
                                                const Color(0xFF121212),
                                            barrierDismissible: true,
                                            title: 'Alert',
                                            titleStyle: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'gg_sans',
                                                color: Colors.white),
                                            middleText:
                                                'Are you sure you want to unfriend ${friendsController.friendsData[index].displayName}',
                                            middleTextStyle: const TextStyle(
                                                fontFamily: 'gg_sans',
                                                color: Colors.white,
                                                fontSize: 15),
                                            textCancel: "Cancel",
                                            textConfirm: "Confirm",
                                            cancelTextColor: Colors.white,
                                            confirmTextColor: Colors.white,
                                            buttonColor: const Color.fromARGB(
                                                255, 255, 77, 0),
                                            onConfirm: () {
                                              friendsController
                                                  .removeFriend(index);
                                              Get.back();
                                            });
                                      })
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                );
        });
  }
}
