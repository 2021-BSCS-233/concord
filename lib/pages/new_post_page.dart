import 'package:concord/controllers/main_controller.dart';
import 'package:concord/controllers/new_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPostPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final NewPostController newPostController = Get.put(NewPostController());
  final Function refreshContent;

  NewPostPage({super.key, required this.refreshContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Post',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xD0FFFFFF),
              fontSize: 22),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result =
              await newPostController.sendPost(mainController.currentUserData.id);
          if(result){
            refreshContent();
            Get.delete<NewPostController>();
            Get.back();
          }
        },
        backgroundColor: Colors.blueAccent.shade400,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.send,
          size: 30,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              // const SizedBox(height: 5),
              TextFormField(
                minLines: 1,
                maxLines: 3,
                maxLength: 90,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
                controller: newPostController.titleTextController,
              ),
              // const SizedBox(height: 10),
              const Divider(
                thickness: 2,
              ),
              const Text(
                'Description:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              // const SizedBox(height: 5),
              TextFormField(
                minLines: 5,
                maxLines: 14,
                maxLength: 900,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
                controller: newPostController.descriptionTextController,
              ),
              const Divider(),
              const Text('Categories: (debug only, divide with ",")'),
              TextFormField(
                maxLines: 1,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                controller: newPostController.debugCategoriesTextController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
