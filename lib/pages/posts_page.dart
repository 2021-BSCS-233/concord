import 'package:concord/controllers/posts_controller.dart';
import 'package:concord/widgets/post_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsPage extends StatelessWidget {
  final PostsController postsController = Get.put(PostsController());

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
          onPressed: () {},
          child: const Icon(Icons.add),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("We could not access our services"),
                      Text("Check your connection or try again later")
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Future<Widget> postsData() async {
    return TabBarView(children: [
      Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ListView.builder(
            itemCount: postsController.postsData.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return PostTile(postData: postsController.postsData[index]);
            }),
      ),
      const Center(child: Text('Follower specific posts')),
    ]);
  }
}
