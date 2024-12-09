import 'dart:io';
import 'package:concord/models/posts_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:core';
import 'package:concord/widgets/message_tile.dart';
import 'package:concord/widgets/popup_menus.dart';
import 'package:concord/widgets/input_field.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/controllers/post_controller.dart';

class PostPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  late final PostController postController = Get.put(PostController());
  final PostsModel postData;

  PostPage({super.key, required this.postData}) {
    postController.postId = postData.id!;
    postController.initial = true;
    postController.userMap[mainController.currentUserData.id] =
        mainController.currentUserData;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(postData.title,
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
                                Text(
                                    "Check your connection or try again later")
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
                    visible: postController.attachmentVisible.value &&
                        postController.updateA == postController.updateA,
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey.shade900,
                          child: ListView.builder(
                              itemCount: postController.attachments.length,
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
                                                  postController
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
                                          postController
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
                        fieldFocusNode: postController.postFocusNode,
                        fieldRadius: 20,
                        fieldLabel: 'Send a message in "${postData.title}"',
                        controller: postController.postFieldTextController,
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
              visible: postController.showMenu.value ||
                  postController.showProfile.value,
              child: GestureDetector(
                onTap: () {
                  postController.showMenu.value = false;
                  postController.showProfile.value = false;
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
              bottom: postController.showMenu.value
                  ? 0.0
                  : -MediaQuery.of(context).size.height,
              left: 0.0,
              right: 0.0,
              child: Container()
              // child: postController.postContent.isNotEmpty
              //     ? ChatMessagePopup(
              //         chatId: postData.id!,
              //       )
              //     : Container(),
            )),
        Obx(() => AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom: postController.showProfile.value
                  ? 0.0
                  : -MediaQuery.of(context).size.height,
              left: 0.0,
              right: 0.0,
              child: postController.postContent.isNotEmpty
                  ? ProfilePopup(
                      selectedUser: postController
                          .postContent[postController.messageSelected].senderId)
                  : Container(),
            )),
      ],
    );
  }

  Future<Widget> messagesUI() async {
    postController.initial
        ? await postController.getPostMessages(postData.id!)
        : null;
    return Obx(
      () => Expanded(
        child: ListView.builder(
          itemCount: postController.postContent.length,
          shrinkWrap: postController.updateP.value == 1 ? true : true,
          itemBuilder: (context, index) {
            return MessageTileFull(
              messageData: postController.postContent[index],
              sendingUser: postController
                  .userMap[postController.postContent[index].senderId],
              toggleMenu: () {
                postController.toggleMenu(index);
              },
              toggleProfile: () {
                postController.toggleProfile(index);
              },
            );
          },
        ),
      ),
    );
  }
}
