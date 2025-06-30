import 'package:concord/controllers/notification_controller.dart';
import 'package:concord/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/controllers/main_controller.dart';

class NotificationsPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final NotificationController notificationController =
      Get.find<NotificationController>();

  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xD0FFFFFF),
              fontSize: 22),
        ),
      ),
      body: FutureBuilder<Widget>(
        future: notificationUI(),
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
                      Text("Check your connection or try again later"),
                    ],
                  ),
                ));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<Widget> notificationUI() async {
    notificationController.initial
        ? await notificationController
            .getInitialData(mainController.currentUserData.id!)
        : null;
    return GetBuilder(
        init: notificationController,
        builder: (controller) {
          return ListView.builder(
              itemCount: notificationController.notificationContent.length,
              itemBuilder: (context, index) {
                var difference = DateTime.now().difference(
                    notificationController
                        .notificationContent[index].timeStamp);
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
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () {
                      if (notificationController
                              .notificationContent[index].sourceType ==
                          'posts') {
                        debugPrint(
                            'redirect to ${notificationController.notificationContent[index].sourceDoc}');
                      } else {
                        debugPrint('open friends chat');
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF121218),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ListTile(
                        titleAlignment: ListTileTitleAlignment.top,
                        leading: ProfilePicture(
                          profileLink: notificationController
                              .notificationContent[index]
                              .fromUserData!
                              .profilePicture,
                          profileRadius: 20,
                        ),
                        title: notificationController
                                    .notificationContent[index].sourceType ==
                                'requests'
                            ? Text.rich(
                                TextSpan(
                                  text: notificationController
                                      .notificationContent[index]
                                      .fromUserData!
                                      .displayName,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF9E9EAA)),
                                  children: const [
                                    TextSpan(
                                        text: ' was added as a friend',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w300,
                                            color: Color(0xFF9E9EAA))),
                                  ],
                                ),
                              )
                            //TODO: use a function in controller to make this string? its getting messy
                            : Text.rich(
                                TextSpan(
                                  text:
                                      '${notificationController.notificationContent[index].fromUserData!.displayName}'
                                      ' ${notificationController.notificationContent[index].sourcePostData!.poster == mainController.currentUserData.id! ? 'sent a message in your post' : 'replied to you in post'}',
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xFF9E9EB1)),
                                  children: [
                                    TextSpan(
                                        text:
                                            ' "${notificationController.notificationContent[index].sourcePostData!.title}"',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF9E9EB1))),
                                  ],
                                ),
                              ),
                        trailing: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(timeDifference,
                                style: const TextStyle(
                                    // fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF9E9EB1)))),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
