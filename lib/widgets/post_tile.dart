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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
          padding: const EdgeInsets.only(top: 13,left: 13,right: 13,bottom: 7),
          // padding: const EdgeInsets.all(13),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Color(0xFF121218),
            // color: Color.fromARGB(255, 120, 186, 227),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
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
                    mainController.chatListenerRef = null;
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
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xD0FFFFFF),
                        )),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    postData.description,
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const Padding(
              //       padding: EdgeInsets.only(top:2),
              //       child: Text("3.2k", style: TextStyle(fontSize: 16)),
              //     ),
              //     Container(
              //       margin: const EdgeInsets.only(left:  10,bottom: 0,top: 0),
              //       child: const Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Icon(Icons.thumb_up_outlined,size: 20,),
              //           SizedBox(width: 12,),
              //           Icon(Icons.thumb_down_outlined,size: 20,),
              //           SizedBox(width: 12,),
              //         ],
              //       ),
              //     ),
              //     const Padding(
              //       padding: EdgeInsets.only(top:2),
              //       child: Text("2.1k", style: TextStyle(fontSize: 16)),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
