import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/controllers/page_controllers.dart';
import 'package:concord/widgets/status_icons.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:image_picker/image_picker.dart';

// var _selectedColor = Color(0xFFFFC42C).obs;
class EditProfilePage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final EditProfileController editProfileController =
      Get.put(EditProfileController());

  EditProfilePage({
    super.key,
  }) {
    editProfileController.displayController.text =
        mainController.currentUserData.displayName;
    editProfileController.pronounceController.text =
        mainController.currentUserData.pronouns;
    editProfileController.aboutMeController.text =
        mainController.currentUserData.aboutMe;
    editProfileController.image = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121218),
      appBar: AppBar(
        title: Text(
          'editProfile'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () async {
              await updateProfile(
                  mainController.currentUserData.id,
                  editProfileController.displayController.text.trim() != ''
                      ? editProfileController.displayController.text.trim()
                      : mainController.currentUserData.displayName,
                  editProfileController.pronounceController.text.trim(),
                  editProfileController.aboutMeController.text.trim(),
                  editProfileController.image);
              Get.back();
            },
            child: SizedBox(
              height: 50,
              width: 80,
              child: Center(
                child: Text(
                  'save'.tr,
                  style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
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
                    Container(
                      width: double.infinity,
                      height: 150,
                      color: Colors.yellow.shade700,
                    ),
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
                      editProfileController.image = result?.path;
                      // var result = await FilePicker.platform.pickFiles(type: FileType.image);
                      // editProfileController.image = result?.files.single.path;
                      editProfileController.updateP.value += 1;
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
                                  width: 6, color: Color(0xFF121218))),
                          child: Obx(() => CircleAvatar(
                                backgroundImage: editProfileController
                                                .updateP.value ==
                                            editProfileController
                                                .updateP.value &&
                                        editProfileController.image != null
                                    ? FileImage(
                                        File(editProfileController.image))
                                    : mainController.currentUserData.profilePicture !=
                                            ''
                                        ? CachedNetworkImageProvider(
                                            mainController.currentUserData.profilePicture)
                                        : const AssetImage(
                                                'assets/images/default.png')
                                            as ImageProvider,
                                // radius: 10,
                                backgroundColor: Colors.grey.shade900,
                              )),
                        ),
                        Positioned(
                          bottom: 3,
                          right: 3,
                          child: StatusIcon(
                            iconType: mainController
                                .currentUserData.displayStatus,
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
                              decoration: BoxDecoration(
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
              decoration: BoxDecoration(
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
                      controller: editProfileController.displayController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: const OutlineInputBorder(),
                        labelText:
                            mainController.currentUserData.displayName,
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
                      controller: editProfileController.pronounceController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: const OutlineInputBorder(),
                          labelText:
                              mainController.currentUserData.pronouns),
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
                      controller: editProfileController.aboutMeController,
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
