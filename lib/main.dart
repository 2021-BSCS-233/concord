import 'package:concord/pages/login_page.dart';
import 'package:concord/pages/notification_page.dart';
import 'package:concord/pages/posts_page.dart';
import 'package:concord/widgets/profile_picture.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:concord/pages/chats_page.dart';
import 'package:concord/pages/profile_page.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:concord/controllers/language_controller.dart';
import 'package:concord/widgets/popup_menus.dart';
import 'package:concord/widgets/status_icons.dart';
import 'package:concord/firebase_options.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Get.put(LocalizationController(prefs: prefs), permanent: true);
  Get.put(MainController(), permanent: true);
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      textTheme: ThemeData.dark().textTheme.copyWith(
            bodyLarge: const TextStyle(fontFamily: 'gg_sans'),
            bodyMedium: const TextStyle(fontFamily: 'gg_sans'),
            bodySmall: const TextStyle(fontFamily: 'gg_sans'),
          ),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(fontFamily: 'gg_sans'),
          toolbarTextStyle: TextStyle(fontFamily: 'gg_sans')),
      scaffoldBackgroundColor: Colors.black,
    ),
    translations: Messages(),
    locale: Get.locale,
    fallbackLocale: const Locale('en', ''),
    home:
        InitialLoading(), // default is suppose to be InitialLoading() any other page is debugging
  ));
}

bool initialMain = true;

class InitialLoading extends StatelessWidget {
  InitialLoading({super.key});

  final MyAuthentication authentication = MyAuthentication();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _buildContent(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
          debugPrint("${snapshot.error}");
          return Material(
              color: Colors.transparent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.error.toString()),
                  ],
                ),
              ));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<Widget> _buildContent(BuildContext context) async {
    bool response = false;
    initialMain ? (response = await authentication.autoLoginFirebase()) : null;
    if (response) {
      return Home();
    } else {
      return LogInPage();
    }
  }
}

class Home extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final MyFirestore myFirestore = MyFirestore();

  Home({
    super.key,
  }) {
    myFirestore.profileListenerFirebase(mainController.currentUserData.id!);
  }

  @override
  Widget build(BuildContext context) {
    List pages = [ChatsPage(), PostsPage(), NotificationsPage(), ProfilePage()];
    var shSize = MediaQuery.sizeOf(context).height;

    return Stack(
      children: [
        Column(
          children: [
            Obx(() =>
                Expanded(child: pages[mainController.selectedIndex.value])),
            Obx(() => BottomNavigationBar(
                  currentIndex: mainController.selectedIndex.value,
                  onTap: (index) {
                    mainController.selectedIndex.value = index;
                    // if (index == 0) {
                    //   mainController.showOverlay(context, 'testing\noverlay');
                    // }
                  },
                  unselectedFontSize: 10,
                  selectedFontSize: 10,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.grey,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                        icon: const Icon(CupertinoIcons.chat_bubble_2_fill),
                        label: 'messages'.tr),
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.people), label: 'Posts'),
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.notifications),
                        label: 'Notifications'),
                    BottomNavigationBarItem(
                        icon: GetBuilder(
                            init: mainController,
                            id: 'profileSection',
                            builder: (controller) {
                              return SizedBox(
                                height: 26,
                                width: 32,
                                child: Stack(
                                  children: [
                                    ProfilePicture(
                                      profileLink: controller
                                          .currentUserData.profilePicture,
                                      profileRadius: 11.5,
                                    ),
                                    Positioned(
                                      bottom: -1,
                                      right: -1,
                                      child: StatusIcon(
                                        iconType: controller
                                            .currentUserData.displayStatus,
                                        borderColor: const Color(0xFF222222),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        label: 'profile'.tr),
                  ],
                )),
          ],
        ),
        Obx(() => Visibility(
              visible: mainController.showMenu.value ||
                  mainController.showProfile.value ||
                  mainController.showStatus.value,
              child: GestureDetector(
                onTap: () {
                  mainController.showMenu.value = false;
                  mainController.showProfile.value = false;
                  mainController.showStatus.value = false;
                },
                child: Container(
                  color: const Color(0xC01D1D1F),
                ),
              ),
            )),
        Obx(() => AnimatedPositioned(
              duration: Duration(
                  milliseconds: mainController.showMenu.value ? 200 : 400),
              curve: Curves.easeInOut,
              bottom: mainController.showMenu.value ? 0.0 : -shSize,
              left: 0.0,
              right: 0.0,
              child: UserGroupPopup(),
            )),
        Obx(() => AnimatedPositioned(
              duration: Duration(
                  milliseconds: mainController.showStatus.value ? 200 : 400),
              curve: Curves.easeInOut,
              bottom: mainController.showStatus.value ? 0.0 : -shSize,
              left: 0.0,
              right: 0.0,
              child: StatusPopup(
                  id: mainController.currentUserData.id!,
                  status: mainController.currentUserData.displayStatus),
            )),
        Obx(() => AnimatedPositioned(
              duration: Duration(
                  milliseconds: mainController.showProfile.value ? 200 : 400),
              curve: Curves.easeInOut,
              bottom: mainController.showProfile.value ? 0.0 : -shSize,
              left: 0.0,
              right: 0.0,
              child: ProfilePopup(selectedUser: mainController.selectedUserId),
            ))
      ],
    );
  }
}

/* things to add in UI page
  account page:
    change email
    change username
    change password
    log out
    delete account(maybe)
  connections: (optional)
    ability to connect other accounts with a link to access them
  appearance: (not happening)
    themes, light, dark, true dark,
    maybe: text size,
    change post attachment size,
  accessibility:
    toggle user colors,
    disable post attachments,
  language:
    options for various languages
  notifications: (important)
    overall off,
    chat notifications section:
      posts created by friends,
      //will provide chat specific settings
      dms:
        all messages, nothing
      groups:
        all messages, pings, nothing
    post notifications section:
      //will provide post specific settings
      //over all toggle for following
      own created posts:
        all messages, only pings, nothing
      followed posts:
        all messages, only pings, nothing
      followed users:
        newly created posts, nothing
*/
