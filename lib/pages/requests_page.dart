import 'package:concord/widgets/custom_loading_logo.dart';
import 'package:concord/widgets/profile_picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/widgets/input_field.dart';
import 'package:concord/controllers/requests_controller.dart';

class RequestsPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final RequestsController requestsController = Get.find<RequestsController>();

  RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'requests'.tr,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xD0FFFFFF),
                fontSize: 22),
          ),
          bottom: TabBar(
            tabs: [Tab(text: 'incoming'.tr), Tab(text: 'outgoing'.tr)],
            indicatorColor: Colors.transparent,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            dividerColor: Colors.transparent,
          ),
        ),
        body: FutureBuilder<Widget>(
          future: requestsData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else if (snapshot.hasError) {
              debugPrint('${snapshot.error}');
              return const Material(
                color: Colors.transparent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("We could not access our services"),
                      Text("Check your connection or try again later")
                    ],
                  ),
                ),
              );
            }
            return const CustomLoadingLogo();
          },
        ),
      ),
    );
  }

  Future<Widget> requestsData() async {
    requestsController.initial
        ? await requestsController
            .getInitialData(mainController.currentUserData.id)
        : null;
    return TabBarView(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10),
          child: GetBuilder(
              init: requestsController,
              id: 'IRSection',
              builder: (controller) {
                return controller.incomingRequestsData.isEmpty
                    ? Center(
                        child: Text('incomingEmpty'.tr),
                      )
                    : Expanded(
                        child: ListView.builder(
                            itemCount: controller.incomingRequestsData.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(top: 15),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF121218),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: ListTile(
                                  dense: true,
                                  leading: ProfilePicture(
                                    profileLink: controller
                                        .incomingRequestsData[index]
                                        .user!
                                        .profilePicture,
                                    profileRadius: 17,
                                  ),
                                  title: Text(
                                    controller.incomingRequestsData[index].user!
                                        .displayName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(controller
                                      .incomingRequestsData[index]
                                      .user!
                                      .username),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          child: const SizedBox(
                                              width: 35,
                                              height: 40,
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              )),
                                          onTap: () {
                                            requestsController.inRequestAction(
                                                index, 'accept');
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          child: const SizedBox(
                                              width: 35,
                                              height: 40,
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              )),
                                          onTap: () {
                                            requestsController.inRequestAction(
                                                index, 'deny');
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
              }),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      fieldLabel: 'Add Friend',
                      controller:
                          requestsController.requestsFieldTC,
                      prefixIcon: CupertinoIcons.person_add,
                      onChange: requestsController.changing,
                      contentTopPadding: 10,
                    ),
                  ),
                  Obx(() => Visibility(
                        visible: requestsController.fieldCheck.value,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueAccent.shade700),
                          width: 40,
                          height: 40,
                          child: TextButton(
                            onPressed: () {
                              requestsController.sendRequest();
                            },
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(0),
                              ),
                            ),
                            child: const Icon(
                              Icons.send,
                              size: 25,
                            ),
                          ),
                        ),
                      ))
                ],
              ),
              GetBuilder(
                  init: requestsController,
                  id: 'ORSection',
                  builder: (controller) {
                    return Expanded(
                      child: controller.outgoingRequestsData.isEmpty
                          ? Center(
                              child: Text('outgoingEmpty'.tr),
                            )
                          : ListView.builder(
                              itemCount: controller.outgoingRequestsData.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF121218),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    leading: ProfilePicture(
                                      profileLink: controller
                                          .outgoingRequestsData[index]
                                          .user!
                                          .profilePicture,
                                      profileRadius: 17,
                                    ),
                                    title: Text(
                                      controller.outgoingRequestsData[index]
                                          .user!.displayName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    subtitle: Text(controller
                                        .outgoingRequestsData[index]
                                        .user!
                                        .username),
                                    trailing: InkWell(
                                      child: const SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          )),
                                      onTap: () {
                                        requestsController.outRequestAction(
                                            index, 'deny');
                                      },
                                    ),
                                  ),
                                );
                              }),
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }
}