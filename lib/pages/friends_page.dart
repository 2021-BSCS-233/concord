import 'package:concord/widgets/profile_picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/pages/requests_page.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/controllers/friends_controller.dart';
import 'package:concord/services/firebase_services.dart';

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
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xD0FFFFFF),
              fontSize: 22),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(RequestsPage());
            },
            child: Container(
              height: 40,
              width: 130,
              decoration: BoxDecoration(
                  color: Colors.blueAccent.shade700,
                  borderRadius: const BorderRadius.all(Radius.circular(25))),
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
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<Widget> friendsUI() async {
    return Obx(() => friendsController.updateF.value ==
                friendsController.updateF.value &&
            friendsController.friendsData.isEmpty
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
                itemCount: friendsController.friendsData.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      color: Color(0xFF121218),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: ListTile(
                      leading: InkWell(
                        onTap: () {
                          mainController.toggleProfile(
                              friendsController.friendsData[index].id);
                        },
                        child: ProfilePicture(
                          profileLink: friendsController.friendsData[index].profilePicture,
                          profileRadius: 20,
                        ),
                      ),
                      title: Text(
                        friendsController.friendsData[index].displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: SizedBox(
                        width: 70,
                        child: Row(
                          children: [
                            InkWell(
                              enableFeedback: true,
                              child: const Icon(
                                  CupertinoIcons.chat_bubble_text_fill),
                              onTap: () {
                                // Get.to(Chat(
                                //   chatId: friendsData[index]['chat_id'],
                                //   otherUsersData: friendsData[index],
                                //   currentUserData: currentUserData,
                                //   chatType: 'dm',
                                // ));
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
                              onTap: () {
                                removeFriend(
                                    mainController.currentUserData.id,
                                    friendsController.friendsData[index].id);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ));
  }
}
