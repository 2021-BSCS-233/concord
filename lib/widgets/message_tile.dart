import 'package:concord/models/messages_model.dart';
import 'package:concord/models/users_model.dart';
import 'package:concord/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'lazy_cached_image.dart';

class MessageTileFull extends StatelessWidget {
  final MessagesModel messageData;
  final UsersModel sendingUser;
  final Function toggleMenu;
  final Function toggleProfile;

  const MessageTileFull(
      {super.key,
      required this.messageData,
      required this.sendingUser,
      required this.toggleMenu,
      required this.toggleProfile});

  @override
  Widget build(BuildContext context) {
    var time = messageData.timeStamp;
    var timeNow = DateTime.now();
    var formattedDateTime = '';
    if (timeNow.year == time!.year &&
        timeNow.month == time.month &&
        timeNow.day == time.day) {
      DateFormat formatter = DateFormat('hh:mm a');
      formattedDateTime = 'Today at ${formatter.format(time)}';
    } else {
      DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');
      formattedDateTime = formatter.format(time);
    }

    return Container(
      margin: const EdgeInsets.only(left: 18, top: 16, right: 18, bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              toggleProfile();
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
                toggleMenu();
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
                              color: Color(0xFFEEEEEE)),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        formattedDateTime,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  messageData.message == ''
                      ? const SizedBox()
                      : RichText(
                          text: TextSpan(
                          text: messageData.message,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
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
                  messageData.attachments!.isEmpty
                      ? const SizedBox()
                      : Attachments(
                          attachments: messageData.attachments!,
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MessageTileCompact extends StatelessWidget {
  final MessagesModel messageData;
  final Map sendingUser;
  final Function toggleMenu;

  const MessageTileCompact(
      {super.key,
      required this.messageData,
      required this.toggleMenu,
      required this.sendingUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 1),
      child: InkWell(
        onLongPress: () {
          toggleMenu();
        },
        // enableFeedback: false,
        splashColor: Colors.black,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: 15,
              width: 48,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                messageData.message == ''
                    ? const SizedBox()
                    : RichText(
                        text: TextSpan(
                          text: messageData.message,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFDEDEE2)),
                          children: messageData.edited
                              ? [
                                  TextSpan(
                                      text: ' (edited)',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade400)),
                                ]
                              : null,
                        ),
                      ),
                messageData.attachments!.isEmpty
                    ? const SizedBox()
                    : Attachments(attachments: messageData.attachments!)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Attachments extends StatelessWidget {
  final List<String> attachments;

  const Attachments({super.key, required this.attachments});

  @override
  Widget build(BuildContext context) {
    var swSize = MediaQuery.of(context).size.width;
    int remainder = 0;
    int size = 0;
    if (attachments.length > 4) {
      remainder = attachments.length % 3;
      size = attachments.length - remainder;
    }
    // return ListView.builder(
    //     itemCount: attachments.length,
    //     shrinkWrap: true,
    //     itemBuilder: (context, index) {
    //       return Text(
    //         attachments[index],
    //         overflow: TextOverflow.ellipsis,
    //       );
    //     });
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
                          height: 200,
                          width: attachments.length == 3
                              ? swSize * 0.5
                              : swSize * 0.8,
                          child: LazyCachedImage(url: attachments[0],)),
                    ),
                    attachments.length == 3
                        ? Column(
                            children: [
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                  height: 102,
                                  width: 95,
                                  child: LazyCachedImage(url: attachments[1],)),
                              SizedBox(
                                  height: 98,
                                  width: 95,
                                  child: LazyCachedImage(url: attachments[2],)),
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
                          child: LazyCachedImage(url: attachments[0],)),
                    ),
                    Flexible(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                          height: attachments.length == 4 ? 100 : 200,
                          width: swSize * 0.4,
                          child: LazyCachedImage(url: attachments[1],)),
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
                          child: LazyCachedImage(url: attachments[2],)),
                    ),
                    Flexible(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                          height: 100,
                          width: swSize * 0.4,
                          child: LazyCachedImage(url: attachments[3],)),
                    ),
                  ],
                )
              : const SizedBox(),
          size > 2
              ? GridView.builder(
                  itemCount: size,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 3,
                  ),
                  itemBuilder: (context, index) {
                    return LazyCachedImage(url: attachments[index],);
                  })
              : const SizedBox()
        ],
      ),
    );
  }
}
//TODO load images to display
