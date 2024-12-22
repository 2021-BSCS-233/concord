import 'dart:io';
import 'package:concord/models/posts_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:core';
import 'package:concord/widgets/message_tile.dart';
import 'package:concord/widgets/popup_menus.dart';
import 'package:concord/widgets/input_field.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/controllers/chat_post_controller.dart';

class PostPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  late final PostController postController =
      Get.put(PostController(collection: 'posts'));
  final PostsModel postData;

  PostPage({super.key, required this.postData}) {
    postController.docRef = postData.docRef;
    postController.initial = true;
    postController.userMap[mainController.currentUserData.id!] =
        mainController.currentUserData;
    postController.userMap[postData.posterData!.id!] = postData.posterData!;
    for (var user in postData.receiverData!) {
      postController.userMap[user.id!] = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    var shSize = MediaQuery.sizeOf(context).height;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(postData.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xD0FFFFFF),
                )),
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
                    visible: postController.attachmentVisible.value,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey.shade900,
                      child: GetBuilder(
                          init: postController,
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
                    visible: postController.editMode.value ||
                        postController.replyMode.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      color: const Color(0xFF151515),
                      width: double.infinity,
                      height: 38,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (postController.editMode.value) {
                                postController.exitEditMode();
                              }
                              if (postController.replyMode.value) {
                                postController.exitReplyMode();
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
                            postController.editMode.value
                                ? 'Editing Message'
                                : 'Replying to ${postController.replyingTo['user']}',
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
                          postController.addAttachments();
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
                        fieldFocusNode: postController.chatFocusNode,
                        fieldRadius: 20,
                        fieldLabel: 'Send a message in "${postData.title}"',
                        controller: postController.chatFieldTextController,
                        suffixIcon: Icons.all_inclusive,
                        fieldColor: const Color(0xFF151515),
                        onChange: postController.sendVisibility,
                        maxLines: 4,
                      ),
                    ),
                    Obx(() => Visibility(
                          visible: postController.sendVisible.value,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueAccent.shade700),
                            width: 40,
                            height: 40,
                            child: TextButton(
                              onPressed: () {
                                postController.sendMessage(
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
                    const SizedBox(width: 10)
                  ],
                )
              ],
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: postController.showMenu.value ||
                  postController.showProfile.value,
              child: GestureDetector(
                onTap: () {
                  postController.showMenu.value = false;
                  postController.showProfile.value = false;
                },
                child: Container(
                  color: const Color(0xCA1D1D1F),
                  height: shSize,
                  width: double.infinity,
                ),
              ),
            )),
        Obx(() => AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom: postController.showMenu.value ? 0.0 : -shSize,
              left: 0.0,
              right: 0.0,
              // child: Container()
              child: postController.chatContent.isNotEmpty
                  ? PostMessagePopup(
                      postId: postData.id!,
                    )
                  : Container(),
            )),
        Obx(() => AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom: postController.showProfile.value ? 0.0 : -shSize,
              left: 0.0,
              right: 0.0,
              child: postController.chatContent.isNotEmpty
                  ? ProfilePopup(
                      selectedUser: postController.messageSelected.senderId)
                  : Container(),
            )),
      ],
    );
  }

  Future<Widget> messagesUI() async {
    postController.initial ? await postController.getMessages() : null;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            GetBuilder(
              init: postController,
              id: 'chatSection',
              builder: (val) {
                return ListView.builder(
                  itemCount: postController.chatContent.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var message = postController.chatContent[
                        postController.chatContent.length - (index + 1)];
                    if (message.repliedTo != null) {
                      return MessageTileFull(
                        messageData: message,
                        sendingUser: postController.userMap[message.senderId]!,
                        toggleMenu: postController.toggleMenu,
                        toggleProfile: postController.toggleProfile,
                        repliedToUser: message.repliedMessage != null
                            ? postController
                                .userMap[message.senderId]!.displayName
                            : '',
                      );
                    } else {
                      return MessageTileFull(
                          messageData: message,
                          sendingUser:
                              postController.userMap[message.senderId]!,
                          toggleMenu: postController.toggleMenu,
                          toggleProfile: postController.toggleProfile);
                    }
                  },
                );
              },
            ),
            Obx(() => ListView.builder(
                itemCount: postController.uploadCount.value,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container();
                })),
          ],
        ),
      ),
    );
  }
}
