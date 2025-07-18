import 'package:concord/controllers/main_controller.dart';
import 'package:concord/controllers/posts_controller.dart';
import 'package:concord/controllers/settings_controller.dart';
import 'package:concord/pages/new_post_page.dart';
import 'package:concord/widgets/custom_loading_logo.dart';
import 'package:concord/widgets/post_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class PostsPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final SettingsController settingsController = Get.find<SettingsController>();
  final PostsController postsController = Get.find<PostsController>();

  PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Posts',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xD0FFFFFF),
                fontSize: 22),
          ),
          bottom: const TabBar(
            tabs: [Tab(text: 'Public Posts'), Tab(text: 'Following')],
            indicatorColor: Colors.transparent,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            dividerColor: Colors.transparent,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => NewPostPage())?.then((value) {
              refreshContent();
            });
          },
          backgroundColor: const Color.fromARGB(255, 255, 77, 0),
          shape: const CircleBorder(),
          child: const Icon(
            Iconsax.add_square,
            size: 30,
          ),
        ),
        body: FutureBuilder<Widget>(
          future: postsData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else if (snapshot.hasError) {
              debugPrint('${snapshot.error}');
              return const Material(
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    "We could not access our services\nCheck your connection or try again later",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return const CustomLoadingLogo();
          },
        ),
      ),
    );
  }

  refreshContent() async {
    await postsController.getInitialPosts(mainController.currentUserData.id);
    postsController.update();
  }

  Future<Widget> postsData() async {
    if (postsController.initial &&
        settingsController.userSettings.postPreference.isNotEmpty) {
      await refreshContent();
    }
    return TabBarView(children: [
      settingsController.userSettings.postPreference.isEmpty
          ? const Center(
              child: Text(
                'Select Post Preference from\nsettings to see posts',
                textAlign: TextAlign.center,
              ),
            )
          : Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: RefreshIndicator(
                  onRefresh: () async {
                    refreshContent();
                    await Future.delayed(
                        const Duration(seconds: 2)); // Simulate a delay
                    return Future.value(null);
                  },
                  child: GetBuilder(
                      init: postsController,
                      builder: (controller) {
                        return ListView.builder(
                            itemCount: controller.publicPosts.length,
                            itemBuilder: (context, index) {
                              return PostTile(
                                  postData: controller.publicPosts[index]);
                            });
                      })),
            ),
      Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: RefreshIndicator(
            onRefresh: () async {
              return refreshContent();
            },
            child: GetBuilder(
                init: postsController,
                builder: (controller) {
                  return ListView.builder(
                      itemCount: controller.followingPosts.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return PostTile(
                            postData: controller.followingPosts[index]);
                      });
                })),
      ),
    ]);
  }
}
