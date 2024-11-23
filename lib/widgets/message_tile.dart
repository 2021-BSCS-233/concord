import 'package:concord/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTileFull extends StatelessWidget {
  final Map messageData;
  final Map sendingUser;
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
    var time = messageData['time_stamp'].toDate();
    var timeNow = DateTime.now();
    var formattedDateTime = '';
    if (timeNow.year == time.year &&
        timeNow.month == time.month &&
        timeNow.day == time.day) {
      DateFormat formatter = DateFormat('hh:mm a');
      formattedDateTime = 'Today at ${formatter.format(time)}';
    } else {
      DateFormat formatter = DateFormat('hh:mm a dd/MM/yyyy');
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
              profileLink: sendingUser['profile_picture'],
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
                          sendingUser['display_name'],
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
                  messageData['message'] == ''
                      ? const SizedBox()
                      : RichText(
                          text: TextSpan(
                          text: messageData['message'],
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFDEDEE2)),
                          children: messageData['edited']
                              ? [
                                  TextSpan(
                                      text: ' (edited)',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500)),
                                ]
                              : null,
                        )),
                  messageData['attachments'] == []
                      ? const SizedBox()
                      : Attachments(
                          attachments: messageData['attachments'],
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
  final Map messageData;
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
              width: 42,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                messageData['message'] == ''
                    ? const SizedBox()
                    : RichText(
                        text: TextSpan(
                          text: messageData['message'],
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFDEDEE2)),
                          children: messageData['edited']
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
                messageData['attachments'].isEmpty
                    ? const SizedBox()
                    : Attachments(attachments: messageData['attachments'])
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Attachments extends StatelessWidget {
  final List attachments;

  const Attachments({super.key, required this.attachments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: attachments.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Text(
            attachments[index],
            overflow: TextOverflow.ellipsis,
          );
        });
  }
}
