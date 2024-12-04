import 'package:concord/controllers/page_controllers.dart';
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
    // if (difference.inMinutes < 1) {
    //   timeDifference = '<1m';
    // } else
    if (difference.inHours < 1) {
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
          Get.to(ChatPage(chatData: chatData));
        },
        onLongPress: () {
          mainController.toggleMenu([
            chatData.id,
            chatData.receiverData![0].username,
            chatData.receiverData![0].profilePicture,
            chatData.chatType
          ]);
        },
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Stack(
          children: [
            ProfilePicture(
              profileLink: chatData.receiverData![0].profilePicture,
              profileRadius: 20,
            ),
            Positioned(
              bottom: -1,
              right: -1,
              child: StatusIcon(
                iconType: chatData.receiverData![0].status == 'Online'
                    ? chatData.receiverData![0].displayStatus
                    : chatData.receiverData![0].status,
              ),
            ),
          ],
        ),
        title: Text(
          chatData.receiverData![0].displayName,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xD0FFFFFF)),
        ),
        subtitle: chatData.latestMessage != ''
            ? Text(
                chatData.latestMessage,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: 14, color: Color(0xB0FFFFFF)),
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
