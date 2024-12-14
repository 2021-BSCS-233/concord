import 'package:concord/controllers/main_controller.dart';
import 'package:concord/models/posts_model.dart';
import 'package:concord/pages/post_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostTile extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final PostsModel postData;

  PostTile({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    var time1 = postData.timeStamp;
    var time2 = DateTime.now();
    var difference = time2.difference(time1);
    String timeDifference = '';
    if (difference.inHours < 1) {
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
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0xFF121218),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 22,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics:
                  const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
              itemCount: postData.categories.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 3),
                  padding: const EdgeInsets.symmetric(
                      vertical: 1.5, horizontal: 7.5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color(0xFF2b2b34),
                  ),
                  child: Text(
                    postData.categories[index],
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          ListTile(
            onTap: (){
              Get.to(PostPage(postData: postData))?.then((value){
                mainController.chatListenerRef?.cancel();
              });
            },
            contentPadding: EdgeInsets.zero,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      postData.posterData!.displayName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xD0FFFFFF)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(timeDifference, style: const TextStyle(fontSize: 12),),
                    ),
                  ],
                ),
                Text(postData.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xD0FFFFFF),
                    )),
              ],
            ),
            subtitle: Text(
              postData.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
