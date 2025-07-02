import 'package:concord/models/messages_model.dart';
import 'package:concord/models/users_model.dart';
import 'package:concord/widgets/profile_picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:concord/widgets/lazy_cached_image.dart';

class MessageTileFull extends StatelessWidget {
  final MessagesModel messageData;
  final UsersModel sendingUser;
  final String? repliedToUser;
  final bool localUser;
  final bool colorDisable;
  final Function toggleMenu;
  final Function toggleProfile;

  const MessageTileFull(
      {super.key,
      required this.messageData,
      required this.sendingUser,
      required this.toggleMenu,
      required this.toggleProfile,
      required this.localUser,
      required this.colorDisable,
      this.repliedToUser});

  @override
  Widget build(BuildContext context) {
    var swSize = MediaQuery.sizeOf(context).width;
    var timeNow = DateTime.now();
    var formattedDateTime = '';
    if (timeNow.year == messageData.timeStamp!.year &&
        timeNow.month == messageData.timeStamp!.month &&
        timeNow.day == messageData.timeStamp!.day) {
      DateFormat formatter = DateFormat('hh:mm a');
      formattedDateTime =
          'Today at ${formatter.format(messageData.timeStamp!)}';
    } else {
      DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');
      formattedDateTime = formatter.format(messageData.timeStamp!);
    }

    return Container(
      margin: const EdgeInsets.only(left: 18, top: 12, right: 18, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          repliedToUser == null
              ? const SizedBox()
              : messageData.repliedMessage == null
                  ? replyMessageWidget('', 'Message was deleted', swSize)
                  : replyMessageWidget(repliedToUser,
                      messageData.repliedMessage!.message, swSize),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  toggleProfile(messageData);
                },
                child: ProfilePicture(
                  profileLink: sendingUser.profilePicture,
                  profileRadius: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onLongPress: () {
                    toggleMenu(messageData);
                  },
                  splashColor: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Text(
                              sendingUser.displayName,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: localUser
                                      ? const Color(0xFF8BC34A)
                                      : const Color(0xFF40C4FF)),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            formattedDateTime,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      messageData.message == ''
                          ? const SizedBox()
                          : Text.rich(TextSpan(
                              text: messageData.message,
                              style: const TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.w100,
                                  color: Color(0xFFDEDEE2)),
                              children: messageData.edited
                                  ? [
                                      TextSpan(
                                          text: ' (edited)',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500)),
                                    ]
                                  : null,
                            )),
                      messageData.attachments.isEmpty
                          ? const SizedBox()
                          : attachments(messageData.attachments, swSize)
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

Widget replyMessageWidget(repliedToUser, message, swSize) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Icon(CupertinoIcons.arrow_turn_up_right),
      ),
      SizedBox(
        width: swSize * (message == '' ? 0.4 : 0.7),
        child: Text(
          repliedToUser != ''
              ? ('$repliedToUser: ${message == '' ? 'attachments' : message}')
              : message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontStyle: repliedToUser != '' ? null : FontStyle.italic,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFCECED2)),
        ),
      ),
      message == ''
          ? Icon(
              Icons.image,
              color: Colors.grey.shade600,
            )
          : const SizedBox()
    ],
  );
}

class MessageTileCompact extends StatelessWidget {
  final MessagesModel messageData;
  final UsersModel sendingUser;
  final Function toggleMenu;

  const MessageTileCompact(
      {super.key,
      required this.messageData,
      required this.toggleMenu,
      required this.sendingUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      child: InkWell(
        onLongPress: () {
          toggleMenu(messageData);
        },
        splashColor: Colors.black,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: 15,
              width: 48,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  messageData.message == ''
                      ? const SizedBox()
                      : Text.rich(TextSpan(
                          text: messageData.message,
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xFFDEDEE2)),
                          children: messageData.edited
                              ? [
                                  TextSpan(
                                      text: ' (edited)',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500)),
                                ]
                              : null,
                        )),
                  messageData.attachments.isEmpty
                      ? const SizedBox()
                      : attachments(messageData.attachments,
                          MediaQuery.sizeOf(context).width)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget attachments(attachments, swSize) {
  int remainder = 0;
  int size = 0;
  if (attachments.length > 4) {
    remainder = attachments.length % 3;
    size = attachments.length - remainder;
  }
  return ClipRRect(
    borderRadius: const BorderRadius.all(
      Radius.circular(20),
    ),
    child: Column(
      children: [
        remainder == 1 || attachments.length == 1 || attachments.length == 3
            ? Row(
                children: [
                  Flexible(
                    child: Container(
                        padding: attachments.length == 3
                            ? const EdgeInsets.fromLTRB(0, 0, 3, 0)
                            : null,
                        height: attachments.length == 1 ? null : 200,
                        width: attachments.length == 1
                            ? null
                            : attachments.length == 3
                                ? swSize * 0.5
                                : swSize * 0.8,
                        child: LazyCachedImage(
                          url: attachments[0],
                        )),
                  ),
                  attachments.length == 3
                      ? Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                height: 102,
                                width: 95,
                                child: LazyCachedImage(
                                  url: attachments[1],
                                )),
                            SizedBox(
                                height: 98,
                                width: 95,
                                child: LazyCachedImage(
                                  url: attachments[2],
                                )),
                          ],
                        )
                      : const SizedBox(),
                ],
              )
            : const SizedBox(),
        remainder == 2 || attachments.length == 2 || attachments.length == 4
            ? Row(
                children: [
                  Flexible(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 3),
                        height: attachments.length == 4 ? 100 : 200,
                        width: swSize * 0.4,
                        child: LazyCachedImage(
                          url: attachments[0],
                        )),
                  ),
                  Flexible(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                        height: attachments.length == 4 ? 100 : 200,
                        width: swSize * 0.4,
                        child: LazyCachedImage(
                          url: attachments[1],
                        )),
                  ),
                ],
              )
            : const SizedBox(),
        attachments.length == 4
            ? Row(
                children: [
                  Flexible(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 3),
                        height: 100,
                        width: swSize * 0.4,
                        child: LazyCachedImage(
                          url: attachments[2],
                        )),
                  ),
                  Flexible(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                        height: 100,
                        width: swSize * 0.4,
                        child: LazyCachedImage(
                          url: attachments[3],
                        )),
                  ),
                ],
              )
            : const SizedBox(),
        size > 2
            ? GridView.builder(
                itemCount: size,
                shrinkWrap: true,
                physics:
                    const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 3,
                ),
                itemBuilder: (context, index) {
                  return LazyCachedImage(
                    url: attachments[index],
                  );
                })
            : const SizedBox()
      ],
    ),
  );
}
