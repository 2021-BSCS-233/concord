import 'package:concord/controllers/friends_controller.dart';
import 'package:concord/controllers/new_group_controller.dart';
import 'package:concord/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/widgets/profile_picture.dart';

class NewGroupPage extends StatelessWidget {
  final FriendsController friendsController = Get.find<FriendsController>();
  late final NewGroupController newGroupController;

  NewGroupPage({super.key}) {
    newGroupController =
        Get.put(NewGroupController(friendsData: friendsController.friendsData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Group',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xD0FFFFFF),
              fontSize: 22),
        ),
        actions: [
          InkWell(
            onTap: () async {
              await newGroupController.createGroup();
              Get.delete<NewGroupController>();
              Get.back();
            },
            child: const SizedBox(
              height: 50,
              width: 80,
              child: Center(
                child: Text(
                  'Create',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Group Name:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            CustomInputField(
              fieldLabel: 'Group Name',
              controller: newGroupController.groupNameTextController,
              fieldRadius: 2,
              horizontalMargin: 0,
              verticalMargin: 2,
              fieldHeight: 50,
              contentTopPadding: 13,
              maxLines: 1,
              maxLength: 40,
              suffixIcon: Icons.all_inclusive,
            ),
            const Text(
              'Add Users',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: newGroupController.updateL.value != -1
                        ? newGroupController.friendsData.length
                        : 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: ProfilePicture(
                          profileLink: newGroupController
                              .friendsData[index].profilePicture,
                          profileRadius: 20,
                        ),
                        title: Text(
                          newGroupController.friendsData[index].displayName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Checkbox(
                            value: newGroupController.markedUsers[index],
                            onChanged: (value) {
                              newGroupController.markedUsers[index] = value!;
                              newGroupController.updateL.value += 1;
                            }),
                      );
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
