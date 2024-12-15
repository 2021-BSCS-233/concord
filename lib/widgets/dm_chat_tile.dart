import 'package:concord/controllers/main_controller.dart';
import 'package:concord/models/chats_model.dart';
import 'package:concord/widgets/profile_picture.dart';
import 'package:concord/widgets/status_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/pages/chat_page.dart';

class DmChatTile extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final ChatsModel chatData;

  DmChatTile({super.key, required this.chatData});

  @override
  Widget build(BuildContext context) {
    var time1 = chatData.timeStamp;
    var time2 = DateTime.now();
    var difference = time2.difference(time1);
    String timeDifference = '';
    if (difference.inMinutes < 1) {
      timeDifference = '<1m';
    } else if (difference.inHours < 1) {
      timeDifference = '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      timeDifference = '${difference.inHours}h';
    } else if (difference.inDays < 30) {
      timeDifference = '${difference.inDays}d';
    } else if (difference.inDays < 365) {
      timeDifference = '${(difference.inDays / 30).floor()}mo';
    } else {
      timeDifference = '${(difference.inDays / 365).floor()}yr';
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.top,
        onTap: () {
          Get.to(ChatPage(chatData: chatData))?.then((value) {
            mainController.chatListenerRef?.cancel();
          });
        },
        onLongPress: () {
          mainController.toggleMenu([
            chatData.id,
            chatData.receiverData![0].id,
            chatData.chatType == 'dm'
                ? chatData.receiverData![0].username
                : chatData.chatGroupName,
            chatData.receiverData![0].profilePicture,
            chatData.chatType
          ]);
        },
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: chatData.chatType == 'dm'
            ? Stack(
                children: [
                  ProfilePicture(
                    profileLink: chatData.receiverData![0].profilePicture,
                    profileRadius: 20,
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: StatusIcon(
                      iconType: chatData.receiverData![0].status == 'Online'
                          ? chatData.receiverData![0].displayStatus
                          : chatData.receiverData![0].status,
                      iconSize: 16.0,
                      iconBorder: 3,
                    ),
                  ),
                ],
              )
            : SizedBox(
                height: 40,
                width: 40,
                child: Stack(
                  children: [
                    ProfilePicture(
                      profileLink: chatData.receiverData![0].profilePicture,
                      profileRadius: 15,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            border: Border.all(width: 2)),
                        child: ProfilePicture(
                          profileLink: chatData.receiverData![1].profilePicture,
                          profileRadius: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        title: Text(
          chatData.chatType == 'dm'
              ? chatData.receiverData![0].displayName
              : chatData.chatGroupName!,
          style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xD0FFFFFF)),
        ),
        subtitle: chatData.latestMessage != ''
            ? Text(
                chatData.latestMessage,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 14, color: Color(0xB0FFFFFF)),
              )
            : const Row(
                children: [
                  Icon(
                    Icons.attachment,
                    color: Color(0xB0FFFFFF),
                    size: 18,
                  ),
                  Text(
                    'attachments',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xB0FFFFFF),
                        fontStyle: FontStyle.italic),
                  )
                ],
              ),
        trailing: Text(timeDifference),
      ),
    );
  }
}
