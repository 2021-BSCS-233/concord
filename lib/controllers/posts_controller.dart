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
// List<PostsModel> postsData = [
//   PostsModel(
//       posterData: UsersModel(
//           username: 'zainali',
//           email: 'temp',
//           displayName: 'Zain',
//           profilePicture: '',
//           status: 'Online',
//           displayStatus: 'Online',
//           pronouns: '',
//           aboutMe: '',
//           friends: [],
//           preference: [],
//           followingPosts: []),
//       poster: '123456',
//       title: 'Build failing error',
//       description: 'My app works fine when i create a new project but then after restarting the studio i get this build failing error',
//       attachments: [],
//       categories: ['Dart', 'Flutter'],
//       followers: ['123456'],
//       timeStamp: DateTime.utc(2024, 12, 6)),
//   PostsModel(
//       posterData: UsersModel(
//           username: 'hammad',
//           email: 'temp',
//           displayName: 'Hammad',
//           profilePicture: '',
//           status: 'Online',
//           displayStatus: 'Online',
//           pronouns: '',
//           aboutMe: '',
//           friends: [],
//           preference: [],
//           followingPosts: []),
//       poster: '123457',
//       title: 'Python code not working properly, only half of it works',
//       description: 'My isnt working as expected, the first few actions seem to work fine but then it fails to display certain pieces of data',
//       attachments: [],
//       categories: ['Python'],
//       followers: ['123457'],
//       timeStamp: DateTime.utc(2024, 11, 7, 12))
// ];
