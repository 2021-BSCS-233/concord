import 'dart:io';
import 'package:concord/models/chats_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:core';
import 'package:concord/widgets/profile_picture.dart';
import 'package:concord/widgets/message_tile.dart';
import 'package:concord/widgets/popup_menus.dart';
import 'package:concord/widgets/input_field.dart';
import 'package:concord/widgets/status_icons.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/controllers/chat_controller.dart';

class ChatPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  late final ChatController chatController = Get.put(ChatController());
  final ChatsModel chatData;

  ChatPage({super.key, required this.chatData}) {
    chatController.userMap.clear();
    chatController.chatId = chatData.id!;
    chatController.initial = true;
    chatController.userMap[mainController.currentUserData.id] =
        mainController.currentUserData;
    for (var user in chatData.receiverData!) {
      chatController.userMap[user.id] = user;
    }
  }



  @override
  Widget build(BuildContext context) {
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
                      : chatData.chatGroupName!,
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
                const SizedBox(
                  height: 10,
                ),
                Obx(() => Visibility(
                    visible: chatController.attachmentVisible.value &&
                        chatController.updateA == chatController.updateA,
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey.shade900,
                          child: ListView.builder(
                              itemCount: chatController.attachments.length,
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
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                          child: Image(
                                              fit: BoxFit.cover,
                                              image: FileImage(File(
                                                  chatController
                                                      .attachments[index]
                                                      .path))),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 2,
                                      child: InkWell(
                                        onTap: () {
                                          chatController
                                              .removeAttachment(index);
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
                              }),
                        ),
                        const SizedBox(height: 5)
                      ],
                    ))),
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
                        fieldFocusNode: chatController.chatFocusNode,
                        fieldRadius: 20,
                        fieldLabel: 'messageTo'.trParams({
                          'name': chatData.chatType == 'dm'
                              ? chatData.receiverData![0].displayName
                              : chatData.chatGroupName!
                        }),
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
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                ),
              ),
            )),
        Obx(() => AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom: chatController.showMenu.value
                  ? 0.0
                  : -MediaQuery.of(context).size.height,
              left: 0.0,
              right: 0.0,
              child: chatController.chatContent.isNotEmpty
                  ? ChatMessagePopup(
                      chatId: chatData.id!,
                    )
                  : Container(),
            )),
        Obx(() => AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom: chatController.showProfile.value
                  ? 0.0
                  : -MediaQuery.of(context).size.height,
              left: 0.0,
              right: 0.0,
              child: chatController.chatContent.isNotEmpty
                  ? ProfilePopup(
                      selectedUser: chatController
                          .chatContent[chatController.messageSelected].senderId)
                  : Container(),
            )),
      ],
    );
  }

  Future<Widget> messagesUI() async {
    chatController.initial
        ? await chatController.getMessages(chatData.id)
        : null;
    return Obx(
      () => chatController.updateC.value == chatController.updateC.value &&
              chatController.chatContent.isEmpty
          ? Center(child: Text('chatEmpty'.tr))
          : Expanded(
              child: NotificationListener(
                onNotification: (ScrollNotification notification) {
                  if (notification.metrics.pixels == 0) {
                    debugPrint('load');
                  }
                  return true;
                },
                child: ListView.builder(
                  itemCount: chatController.chatContent.length,
                  shrinkWrap: true,
                  reverse: true,
                  itemBuilder: (context, index) {
                    try {
                      if (chatController.chatContent[index].senderId !=
                          chatController.chatContent[index + 1].senderId) {
                        return MessageTileFull(
                          messageData: chatController.chatContent[index],
                          sendingUser: chatController.userMap[
                              chatController.chatContent[index].senderId],
                          toggleMenu: () {
                            chatController.toggleMenu(index);
                          },
                          toggleProfile: () {
                            chatController.toggleProfile(index);
                          },
                        );
                      } else {
                        bool select = true;
                        try {
                          var time1 = chatController.chatContent[index].timeStamp;
                          var time2 =
                              chatController.chatContent[index + 1].timeStamp;
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
                              messageData: chatController.chatContent[index],
                              sendingUser: chatController.userMap[
                                  chatController.chatContent[index].senderId],
                              toggleMenu: () {
                                chatController.toggleMenu(index);
                              });
                        } else {
                          return MessageTileFull(
                            messageData: chatController.chatContent[index],
                            sendingUser: chatController.userMap[
                                chatController.chatContent[index].senderId],
                            toggleMenu: () {
                              chatController.toggleMenu(index);
                            },
                            toggleProfile: () {
                              chatController.toggleProfile(index);
                            },
                          );
                        }
                      }
                    } catch (e) {
                      return MessageTileFull(
                        messageData: chatController.chatContent[index],
                        sendingUser: chatController
                            .userMap[chatController.chatContent[index].senderId],
                        toggleMenu: () {
                          chatController.toggleMenu(index);
                        },
                        toggleProfile: () {
                          chatController.toggleProfile(index);
                        },
                      );
                    }
                  },
                ),
              ),
            ),
    );
  }
}
