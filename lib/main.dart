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
import 'package:concord/services/language_controller.dart';
import 'package:concord/widgets/popup_menus.dart';
import 'package:concord/widgets/status_icons.dart';
import 'package:concord/firebase_options.dart';
import 'package:concord/services/page_controllers.dart';
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
    home: const Loading(),
  ));
}

bool initialMain = true;

class Loading extends StatelessWidget {
  const Loading({super.key});

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
    List userData = [];
    initialMain ? (userData = await autoLogin()) : null;
    if (userData[0]) {
      userData[1]['id'] = userData[2].user.uid;
      return Home(
        userData: userData[1],
      );
    } else {
      debugPrint('failed due to :${userData[1]}');
      return LogIn();
    }
  }
}

class Home extends StatelessWidget {
  final Map userData;
  late final MainController mainController = Get.find<MainController>();

  Home({
    super.key,
    required this.userData,
  }) {
    mainController.currentUserData = userData;
    mainController.selectedIndex.value = 0;
    profileListener(userData['id']);
  }

  @override
  Widget build(BuildContext context) {
    List pages = [Chats(mainController: mainController,), Posts(), Notifications(), Profile()];

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
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.people), label: 'Posts'),
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.notifications),
                        label: 'Notifications'),
                    BottomNavigationBarItem(
                        icon: Obx(() => SizedBox(
                              height:
                                  mainController.updateM.value == 1 ? 26 : 26,
                              width: 32,
                              child: Stack(
                                children: [
                                  ProfilePicture(
                                      profileLink: mainController
                                          .currentUserData['profile_picture'],
                                      profileRadius: 11.5,),
                                  Positioned(
                                    bottom: -1,
                                    right: -1,
                                    child: StatusIcon(
                                      iconType: mainController
                                          .currentUserData['display_status'],
                                      borderColor: const Color(0xFF222222),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        label: 'profile'.tr),
                  ],
                )),
          ],
        ),
        Obx(() => Visibility(
              visible: mainController.showMenu.value ||
                  mainController.showProfile.value,
              child: GestureDetector(
                onTap: () {
                  mainController.selectedUserId = '';
                  mainController.showMenu.value = false;
                  mainController.showProfile.value = false;
                },
                child: Container(
                  color: Color(0xC01D1D1F),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                ),
              ),
            )),
        Obx(() => AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom: mainController.showMenu.value
                  ? 0.0
                  : -MediaQuery.of(context).size.height,
              left: 0.0,
              right: 0.0,
              child: mainController.selectedIndex.value == 0
                  ? UserGroupPopup(
                      tileContent: [
                        mainController.selectedUserId,
                        mainController.selectedUsername,
                        mainController.selectedUserPic,
                        mainController.selectedChatType
                      ],
                    )
                  : mainController.selectedIndex.value == 3
                      ? StatusPopup(
                          currentUserData: mainController.currentUserData)
                      : Container(),
            )),
        Obx(() => AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom: mainController.showProfile.value
                  ? 0.0
                  : -MediaQuery.of(context).size.height,
              left: 0.0,
              right: 0.0,
              child: mainController.selectedUserId == ''
                  ? Container()
                  : ProfilePopup(selectedUser: mainController.selectedUserId),
            ))
      ],
    );
  }
}

//future builder code cuz i keep forgetting
// @override
// Widget build(BuildContext context) {
//   return FutureBuilder<Widget>(
//     future: _buildContent(context),
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         return snapshot.data!;
//       } else if (snapshot.hasError) {
//         return Text("${snapshot.error}");
//       }
//       return CircularProgressIndicator();
//     },
//   );
// }
//
// Future<Widget> _buildContent(BuildContext context) async {
