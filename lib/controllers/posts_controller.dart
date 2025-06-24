import 'package:concord/models/posts_model.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  final MyFirestore myFirestore = MyFirestore();
  bool initial = true;
  List<PostsModel> publicPosts = [];
  List<PostsModel> followingPosts = [];

  getInitialPosts(currentUserId, preference) async {
    var result =
        await myFirestore.getInitialPostsFirebase(currentUserId, preference);
    publicPosts = result[0];
    followingPosts = result[1];
    initial = false;
    update();
  }
}
