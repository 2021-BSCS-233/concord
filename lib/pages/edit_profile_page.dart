import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/controllers/edit_profile_controller.dart';
import 'package:concord/widgets/status_icons.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final EditProfileController editProfileController =
      Get.put(EditProfileController());

  EditProfilePage({
    super.key,
  }) {
    editProfileController.displayTC.text =
        mainController.currentUserData.displayName;
    editProfileController.pronounceTC.text =
        mainController.currentUserData.pronouns;
    editProfileController.aboutMeTC.text =
        mainController.currentUserData.aboutMe;
    editProfileController.image = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121218),
      appBar: AppBar(
        title: Text(
          'editProfile'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () async {
              await editProfileController.updateProfile();
              Get.back();
            },
            child: Container(
              margin: const EdgeInsetsGeometry.only(right: 5),
              height: 40,
              width: 80,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 77, 0),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(
                child: Text(
                  'save'.tr,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    mainController.currentUserData.bannerImg == ''
                        ? Container(
                            width: double.infinity,
                            height: 150,
                            //make it adapt to the major color of profile
                            color: Color(
                                mainController.currentUserData.bannerColor),
                          )
                        : Container(), //work on this
                    Container(
                      width: double.infinity,
                      height: 60,
                      color: Colors.transparent,
                    )
                  ],
                ),
                Positioned(
                  bottom: 10,
                  left: 20,
                  child: InkWell(
                    onTap: () async {
                      var result = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      editProfileController.image = result!.path;
                      // var result = await FilePicker.platform.pickFiles(type: FileType.image);
                      // editProfileController.image = result?.files.single.path;
                      editProfileController.update(['profilePicture']);
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 6, color: const Color(0xFF121218))),
                          child: GetBuilder(
                              init: editProfileController,
                              id: 'profilePicture',
                              builder: (controller) {
                                return CircleAvatar(
                                  backgroundImage: controller.image != ''
                                      ? FileImage(File(controller.image))
                                      : mainController.currentUserData
                                                  .profilePicture !=
                                              ''
                                          ? CachedNetworkImageProvider(
                                              mainController.currentUserData
                                                  .profilePicture)
                                          : const AssetImage(
                                                  'assets/images/default.png')
                                              as ImageProvider,
                                  // radius: 10,
                                  backgroundColor: Colors.grey.shade900,
                                );
                              }),
                        ),
                        Positioned(
                          bottom: 3,
                          right: 3,
                          child: StatusIcon(
                            iconType:
                                mainController.currentUserData.displayStatus,
                            iconSize: 24,
                            iconBorder: 4,
                          ),
                        ),
                        Positioned(
                            right: 3,
                            top: 3,
                            child: Container(
                              height: 24,
                              width: 24,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF121218)),
                              child: Icon(
                                Icons.edit,
                                size: 14,
                                color: Colors.grey.shade400,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
              alignment: Alignment.centerLeft,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('displayNameU'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            fontSize: 12)),
                    TextFormField(
                      controller: editProfileController.displayTC,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: const OutlineInputBorder(),
                        labelText: mainController.currentUserData.displayName,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('pronounsU'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            fontSize: 12)),
                    TextFormField(
                      maxLength: 40,
                      controller: editProfileController.pronounceTC,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: const OutlineInputBorder(),
                          labelText: mainController.currentUserData.pronouns),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('aboutMeU'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            fontSize: 12)),
                    TextFormField(
                      controller: editProfileController.aboutMeTC,
                      maxLines: 7,
                      maxLength: 190,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: const OutlineInputBorder(),
                        label: Text(mainController.currentUserData.aboutMe),
                        // labelStyle: TextStyle(overflow: TextOverflow.ellipsis)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
