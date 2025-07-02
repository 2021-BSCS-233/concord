import 'dart:io';
import 'package:concord/controllers/settings_controller.dart';
import 'package:concord/models/chats_model.dart';
import 'package:concord/models/messages_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:core';
import 'package:concord/widgets/profile_picture.dart';
import 'package:concord/widgets/message_tile.dart';
import 'package:concord/widgets/popup_menus.dart';
import 'package:concord/widgets/input_field.dart';
import 'package:concord/widgets/status_icons.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/controllers/chat_post_controller.dart';

class ChatPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final SettingsController settingsController = Get.find<SettingsController>();
  final ChatController chatController =
      Get.put(ChatController(collection: 'chats'));
  final ChatsModel chatData;

  ChatPage({super.key, required this.chatData}) {
    chatController.docRef = chatData.docRef;
    chatController.chatHistory.clear();
    chatController.historyRemaining = true;
    chatController.userMap.clear();
    chatController.initial = true;
    chatController.userMap[mainController.currentUserData.id!] =
        mainController.currentUserData;
    for (var user in chatData.receiverData!) {
      chatController.userMap[user.id!] = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shSize = MediaQuery.sizeOf(context).height;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                chatData.chatType == 'dm'
                    ? Stack(
                        children: [
                          ProfilePicture(
                            profileLink:
                                chatData.receiverData![0].profilePicture,
                            profileRadius: 17,
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: StatusIcon(
                              iconType:
                                  chatData.receiverData![0].status == 'Online'
                                      ? chatData.receiverData![0].displayStatus
                                      : chatData.receiverData![0].status,
                              iconSize: 16.0,
                              iconBorder: 3,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                SizedBox(
                  width: chatData.chatType == 'dm' ? 10 : 0,
                ),
                Text(
                  chatData.chatType == 'dm'
                      ? chatData.receiverData![0].displayName
                      : chatData.chatGroupName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEEEEEE)),
                )
              ],
            ),
          ),
          body: Container(
            padding: const EdgeInsets.only(bottom: 5),
            height: shSize,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FutureBuilder<Widget>(
                  future: messagesUI(),
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
                const SizedBox(height: 5),
                Obx(() => Visibility(
                    visible: chatController.attachmentVisible.value,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey.shade900,
                      child: GetBuilder(
                          init: chatController,
                          id: 'attachmentList',
                          builder: (controller) {
                            return ListView.builder(
                                itemCount: controller.attachments.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          margin: const EdgeInsets.all(10),
                                          height: 120,
                                          width: 100,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                            child: Image(
                                                fit: BoxFit.cover,
                                                image: FileImage(File(controller
                                                    .attachments[index].path))),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 2,
                                        child: InkWell(
                                          onTap: () {
                                            controller.removeAttachment(index);
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade700,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(3))),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.grey.shade500,
                                              )),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          }),
                    ))),
                Obx(() => Visibility(
                    visible: chatController.editMode.value ||
                        chatController.replyMode.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      color: const Color(0xFF151515),
                      width: double.infinity,
                      height: 38,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (chatController.editMode.value) {
                                chatController.exitEditMode();
                              }
                              if (chatController.replyMode.value) {
                                chatController.exitReplyMode();
                              }
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade600,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: Color(0xFF151515),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            chatController.editMode.value
                                ? 'Editing Message'
                                : 'Replying to ${chatController.replyingTo['user']}',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ))),
                const SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: TextButton(
                        onPressed: () {
                          chatController.addAttachments();
                        },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(0),
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
                    ),
                    Expanded(
                      child: CustomInputField(
                        contentTopPadding: 10,
                        fieldFocusNode: chatController.chatFocusNode,
                        fieldRadius: 20,
                        fieldLabel: 'messageTo'.trParams({
                          'name': chatData.chatType == 'dm'
                              ? chatData.receiverData![0].displayName
                              : chatData.chatGroupName
                        }),
                        fieldHint: 'Send a Message',
                        controller: chatController.chatFieldTextController,
                        suffixIcon: Icons.all_inclusive,
                        fieldColor: const Color(0xFF151515),
                        onChange: chatController.sendVisibility,
                        maxLines: 4,
                      ),
                    ),
                    Obx(() => Visibility(
                          visible: chatController.sendVisible.value,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueAccent.shade700),
                            width: 40,
                            height: 40,
                            child: TextButton(
                              onPressed: () {
                                chatController.sendMessage(
                                    mainController.currentUserData.id);
                              },
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(0),
                                ),
                              ),
                              child: const Icon(
                                Icons.send,
                                size: 25,
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: chatController.showMenu.value ||
                  chatController.showProfile.value,
              child: GestureDetector(
                onTap: () {
                  chatController.showMenu.value = false;
                  chatController.showProfile.value = false;
                },
                child: Container(
                  color: const Color(0xCA1D1D1F),
                ),
              ),
            )),
        Obx(() => AnimatedPositioned(
            duration: Duration(
                milliseconds: chatController.showMenu.value ? 200 : 400),
            curve: Curves.easeInOut,
            bottom: chatController.showMenu.value ? 0.0 : -shSize,
            left: 0.0,
            right: 0.0,
            child: ChatMessagePopup(chatId: chatData.id!))),
        Obx(() => AnimatedPositioned(
            duration: Duration(
                milliseconds: chatController.showProfile.value ? 200 : 200),
            curve: Curves.easeInOut,
            bottom: chatController.showProfile.value ? 0.0 : -shSize,
            left: 0.0,
            right: 0.0,
            child: ProfilePopup(
                selectedUser: chatController.messageSelected.senderId))),
      ],
    );
  }

  Future<Widget> messagesUI() async {
    chatController.initial ? await chatController.getMessages() : null;
    return chatController.chatContent.isEmpty
        ? Center(child: Text('chatEmpty'.tr))
        : Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                if (chatController.chatContent.length > 49 &&
                    chatController.historyRemaining) {
                  return await chatController.getMessageHistory();
                }
                return Future.value(null);
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [
                      GetBuilder(
                        init: chatController,
                        id: 'chatHistory',
                        builder: (controller) {
                          return ListView.builder(
                            itemCount: controller.chatHistory.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return messageBuilder(
                                  controller.chatHistory, index);
                            },
                          );
                        },
                      ),
                      GetBuilder(
                        init: chatController,
                        id: 'chatSection',
                        builder: (controller) {
                          return ListView.builder(
                            itemCount: controller.chatContent.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return messageBuilder(
                                  controller.chatContent, index);
                            },
                          );
                        },
                      ),
                      Obx(() => ListView.builder(
                          itemCount: chatController.uploadCount.value,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return Container(
                                margin: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 64, right: 40),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                width: 60,
                                height: 50,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Color(0xFF151515)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Uploading Files',
                                        style: TextStyle(
                                            color: Colors.grey.shade500)),
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade600,
                                      ),
                                      child: const Icon(
                                        Icons.upload_rounded,
                                        size: 18,
                                        color: Color(0xFF151515),
                                      ),
                                    )
                                  ],
                                ));
                          })),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  messageBuilder(List<MessagesModel> content, index) {
    try {
      if (content[index].repliedTo != null) {
        return MessageTileFull(
          colorDisable:
              settingsController.userSettings.accessibility.userColors,
          localUser:
              content[index].senderId == mainController.currentUserData.id,
          messageData: content[index],
          sendingUser: chatController.userMap[content[index].senderId]!,
          toggleMenu: chatController.toggleMenu,
          toggleProfile: chatController.toggleProfile,
          repliedToUser: content[index].repliedMessage != null
              ? chatController
                  .userMap[content[index].repliedMessage!.senderId]!.displayName
              : '',
        );
      } else if (content[index].senderId != content[index + 1].senderId) {
        return MessageTileFull(
            colorDisable:
                settingsController.userSettings.accessibility.userColors,
            localUser:
                content[index].senderId == mainController.currentUserData.id,
            messageData: content[index],
            sendingUser: chatController.userMap[content[index].senderId]!,
            toggleMenu: chatController.toggleMenu,
            toggleProfile: chatController.toggleProfile);
      } else {
        bool select = true;
        try {
          var time1 = content[index].timeStamp;
          var time2 = content[index + 1].timeStamp;
          var difference = time1!.difference(time2!);
          if (difference.inMinutes < 15) {
            select = true;
          } else {
            select = false;
          }
        } catch (e) {
          select = true;
        }
        if (select) {
          return MessageTileCompact(
              messageData: content[index],
              sendingUser: chatController.userMap[content[index].senderId]!,
              toggleMenu: chatController.toggleMenu);
        } else {
          return MessageTileFull(
            colorDisable:
                settingsController.userSettings.accessibility.userColors,
            localUser:
                content[index].senderId == mainController.currentUserData.id,
            messageData: content[index],
            sendingUser: chatController.userMap[content[index].senderId]!,
            toggleMenu: chatController.toggleMenu,
            toggleProfile: chatController.toggleProfile,
          );
        }
      }
    } catch (e) {
      return MessageTileFull(
        colorDisable: settingsController.userSettings.accessibility.userColors,
        localUser: content[index].senderId == mainController.currentUserData.id,
        messageData: content[index],
        sendingUser: chatController.userMap[content[index].senderId]!,
        toggleMenu: chatController.toggleMenu,
        toggleProfile: () {
          chatController.toggleProfile(index);
        },
      );
    }
  }
}
