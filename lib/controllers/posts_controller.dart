import 'package:concord/controllers/settings_controller.dart';
import 'package:concord/models/posts_model.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  final MyFirestore myFirestore = MyFirestore();
  bool initial = true;
  List<PostsModel> publicPosts = [];
  List<PostsModel> followingPosts = [];

  getInitialPosts(currentUserId) async {
    final SettingsController settingsController = Get.find<SettingsController>();
    var result = await myFirestore.getInitialPostsFirebase(
        currentUserId, settingsController.userSettings.postPreference.toList());
    publicPosts = result[0];
    followingPosts = result[1];
    initial = false;
    update();
  }
}
