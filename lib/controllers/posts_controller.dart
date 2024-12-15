import 'package:concord/models/posts_model.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  bool initial = true;
  var updateP = 0.obs;
  List<PostsModel> publicPosts = [];
  List<PostsModel> followingPosts = [];

  getInitialPosts(currentUserId, preference) async {
    var result = await getInitialPostsFirebase(currentUserId, preference);
    publicPosts = result[0];
    followingPosts = result[1];
    initial = false;
    updateP.value +=1;
  }
}