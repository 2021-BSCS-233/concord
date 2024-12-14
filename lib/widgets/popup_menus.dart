import 'package:concord/models/users_model.dart';
import 'package:concord/widgets/profile_picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:concord/controllers/chat_controller.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:concord/widgets/status_icons.dart';
import 'package:concord/widgets/option_tile.dart';

class UserGroupPopup extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();

  // final List tileContent;

  UserGroupPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.56,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    leading: mainController.selectedChatType == 'dm'
                        ? ProfilePicture(
                            profileLink: mainController.selectedUserPic,
                            profileRadius: 25,
                          )
                        : null,
                    title: Text(
                      mainController.selectedChatType == 'dm'
                          ? '@${mainController.selectedUsername}'
                          : mainController.selectedUsername,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),
                ),
                mainController.selectedChatType == 'dm'
                    ? OptionTile(
                        action: () {
                          mainController.showMenu.value = false;
                          mainController.showProfile.value = true;
                        },
                        actionIcon: Icons.person,
                        actionName: 'Profile')
                    : const SizedBox(),
                mainController.selectedChatType == 'dm'
                    ? OptionTile(
                        action: () {
                          hideChatFirebase(mainController.selectedChatId,
                              mainController.currentUserData.id);
                        },
                        actionIcon: Icons.remove_circle_outline,
                        actionName: 'Close DM')
                    : const SizedBox(),
                OptionTile(
                    action: () {
                      debugPrint(
                          'MAR action on ${mainController.selectedChatId}, chat type ${mainController.selectedChatType}');
                    },
                    actionIcon: CupertinoIcons.eye,
                    actionName: 'Mark As Read'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatMessagePopup extends StatelessWidget {
  final String chatId;
  final MainController mainController = Get.find<MainController>();
  final ChatController chatController = Get.find<ChatController>();

  ChatMessagePopup({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.56,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  chatController.chatContent[chatController.messageSelected]
                              .senderId ==
                          mainController.currentUserData.id
                      ? OptionTile(
                          action: () {
                            chatController.editMessage();
                          },
                          actionIcon: Icons.edit,
                          actionName: 'Edit Message')
                      : const SizedBox(),
                  OptionTile(
                      action: () async {
                        await Clipboard.setData(ClipboardData(
                            text: chatController
                                .chatContent[chatController.messageSelected]
                                .message));
                      },
                      actionIcon: Icons.copy,
                      actionName: 'Copy Text'),
                  chatController.chatContent[chatController.messageSelected]
                              .senderId ==
                          mainController.currentUserData.id
                      ? OptionTile(
                          action: () {
                            chatController.deleteMessage();
                          },
                          actionIcon: CupertinoIcons.delete,
                          actionName: 'Delete Message')
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePopup extends StatelessWidget {
  final String selectedUser;

  const ProfilePopup({super.key, required this.selectedUser});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _buildContent(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Container();
        // height: MediaQuery.of(context).size.height * 0.65,
        // child: CircularProgressIndicator());
      },
    );
  }

  Future<Widget> _buildContent(BuildContext context) async {
    UsersModel userProfileData = await getUserProfileFirebase(selectedUser);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      width: double.infinity,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Column(
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.yellow.shade700,
                              //make it adapt to the major color of profile
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25))),
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          color: Colors.transparent,
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 10,
                      left: 20,
                      child: Stack(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 6, color: Colors.black)),
                            child: ProfilePicture(
                                profileLink: userProfileData.profilePicture),
                          ),
                          Positioned(
                            bottom: 3,
                            right: 3,
                            child: StatusIcon(
                              iconType: userProfileData.status == 'Online'
                                  ? userProfileData.displayStatus
                                  : userProfileData.status,
                              iconSize: 24,
                              iconBorder: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 130,
                  decoration: const BoxDecoration(
                      color: Color(0xFF121218),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfileData.displayName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        userProfileData.username,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        userProfileData.pronouns,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                      color: Color(0xFF121218),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'aboutMe'.tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 120,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Text(
                            userProfileData.aboutMe,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey.shade300),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

var selectedValue = 1.obs;

class StatusPopup extends StatelessWidget {
  final String status;
  final String id;

  StatusPopup({super.key, required this.status, required this.id}) {
    if (status == 'DND') {
      selectedValue.value = 2;
    } else if (status == 'Asleep') {
      selectedValue.value = 3;
    } else if (status == 'Offline') {
      selectedValue.value = 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: Column(
                children: [
                  Text(
                    'changeStatus'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'onlineStatus'.tr,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    // height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Color(0xFF121218),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Obx(() => Column(
                          children: [
                            ListTile(
                              leading: const StatusIcon(iconType: 'Online'),
                              title: Text('online'.tr),
                              trailing: Radio(
                                  value: 1,
                                  groupValue: selectedValue.value,
                                  onChanged: (value) async {
                                    var temp = selectedValue.value;
                                    selectedValue.value = value as int;
                                    var result =
                                        await updateStatusDisplayFirebase(
                                            id, 'Online');
                                    if (!result) {
                                      selectedValue.value = temp;
                                    }
                                  }),
                            ),
                            ListTile(
                              leading: const StatusIcon(iconType: 'DND'),
                              title: Text('dnd'.tr),
                              trailing: Radio(
                                  value: 2,
                                  groupValue: selectedValue.value,
                                  onChanged: (value) async {
                                    var temp = selectedValue.value;
                                    selectedValue.value = value as int;
                                    var result =
                                        await updateStatusDisplayFirebase(
                                            id, 'DND');
                                    if (!result) {
                                      selectedValue.value = temp;
                                    }
                                  }),
                            ),
                            ListTile(
                              leading: const StatusIcon(iconType: 'Asleep'),
                              title: Text('idle'.tr),
                              trailing: Radio(
                                  value: 3,
                                  groupValue: selectedValue.value,
                                  onChanged: (value) async {
                                    var temp = selectedValue.value;
                                    selectedValue.value = value as int;
                                    var result =
                                        await updateStatusDisplayFirebase(
                                            id, 'Asleep');
                                    if (!result) {
                                      selectedValue.value = temp;
                                    }
                                  }),
                            ),
                            ListTile(
                              leading: const StatusIcon(iconType: 'Offline'),
                              title: Text('hidden'.tr),
                              trailing: Radio(
                                  value: 4,
                                  groupValue: selectedValue.value,
                                  onChanged: (value) async {
                                    var temp = selectedValue.value;
                                    selectedValue.value = value as int;
                                    var result =
                                        await updateStatusDisplayFirebase(
                                            id, 'Offline');
                                    if (!result) {
                                      selectedValue.value = temp;
                                    }
                                  }),
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
