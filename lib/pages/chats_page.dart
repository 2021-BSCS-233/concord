import 'package:concord/pages/friends_page.dart';
import 'package:concord/pages/new_group_page.dart';
import 'package:concord/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/widgets/dm_chat_tile.dart';
import 'package:concord/widgets/status_icons.dart';
import 'package:concord/controllers/friends_controller.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/controllers/chats_controller.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ChatsPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final ChatsController chatsController = Get.put(ChatsController());
  final FriendsController friendsController = Get.put(FriendsController());

  ChatsPage({super.key}) {
    chatsController.initial = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'messages'.tr,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xD0FFFFFF),
              fontSize: 22),
        ),
        actions: [
          InkWell(
            enableFeedback: true,
            onTap: () {
              Get.to(FriendsPage());
            },
            child: SizedBox(
              height: 40,
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('friends'.tr),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 25,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(NewGroupPage());
        },
        backgroundColor: const Color.fromARGB(255, 255, 77, 0),
        shape: const CircleBorder(),
        child: const Icon(
          Iconsax.people,
          size: 28,
        ),
      ),
      body: FutureBuilder<Widget>(
        future: chatsUI(),
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
                      Text("Check your connection or try again later"),
                    ],
                  ),
                ));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<Widget> chatsUI() async {
    chatsController.initial
        ? await chatsController
            .getInitialData(mainController.currentUserData.id)
        : null;
    friendsController.initial
        ? await friendsController
            .getInitialData(mainController.currentUserData.id)
        : null;
    return Column(
      children: [
        GetBuilder(
            init: friendsController,
            id: 'friendsSection',
            builder: (controller) {
              return SizedBox(
                  width: double.infinity,
                  height: controller.friendsData.isEmpty ? 0 : 107,
                  child: controller.friendsData.isEmpty
                      ? const SizedBox()
                      : ListView.builder(
                          itemCount: controller.friendsData.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  height: 70,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                      color: Color(0xAA18181F),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        mainController.toggleProfile(
                                            controller.friendsData[index].id);
                                      },
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: ProfilePicture(
                                                profileLink: controller
                                                    .friendsData[index]
                                                    .profilePicture),
                                          ),
                                          Positioned(
                                            bottom: -2,
                                            right: -2,
                                            child: StatusIcon(
                                              iconType: controller
                                                          .friendsData[index]
                                                          .status ==
                                                      'Online'
                                                  ? controller.friendsData[index]
                                                      .displayStatus
                                                  : controller
                                                      .friendsData[index].status,
                                              iconSize: 17,
                                              iconBorder: 3.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Text(controller.friendsData[index].displayName),
                              ],
                            );
                          }));
            }),
        GetBuilder(
            init: chatsController,
            id: 'chatsSection',
            builder: (controller) {
              return Expanded(
                  child: controller.chatsData.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'chatsEmpty'.tr,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 90,
                              )
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.chatsData.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return DmChatTile(
                                chatData: controller.chatsData[index]);
                          },
                        ));
            })
      ],
    );
  }
}
