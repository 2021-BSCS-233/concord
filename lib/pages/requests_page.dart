import 'package:concord/widgets/profile_picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/widgets/input_field.dart';
import 'package:concord/services/firebase_services.dart';
import 'package:concord/controllers/requests_controller.dart';

class RequestsPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final RequestsController requestsController = Get.put(RequestsController());

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
            return const Center(child: CircularProgressIndicator());
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
          child: Obx(() => requestsController.updateI.value ==
                      requestsController.updateI.value &&
                  requestsController.incomingRequestsData.isEmpty
              ? Center(
                  child: Text('incomingEmpty'.tr),
                )
              : ListView.builder(
                  itemCount: requestsController.incomingRequestsData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 15),
                      decoration: const BoxDecoration(
                        color: Color(0xFF121218),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: ProfilePicture(
                          profileLink: requestsController
                              .incomingRequestsData[index].user!.profilePicture,
                          profileRadius: 17,
                        ),
                        title: Text(
                          requestsController
                              .incomingRequestsData[index].user!.displayName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(requestsController
                            .incomingRequestsData[index].user!.username),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: const SizedBox(
                                    width: 35,
                                    height: 40,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )),
                                onTap: () async {
                                  await requestActionFirebase(
                                      requestsController
                                          .incomingRequestsData[index].id,
                                      'accept');
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
                                  requestActionFirebase(
                                      requestsController
                                          .incomingRequestsData[index].id,
                                      'deny');
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
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
                      controller: requestsController.requestsFieldTextController,
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
                              requestsController.fieldCheck.value = false;
                              sendRequestFirebase(
                                  mainController.currentUserData.id,
                                  requestsController
                                      .requestsFieldTextController.text
                                      .trim());
                              requestsController.requestsFieldTextController.text =
                                  '';
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
              Obx(() => Expanded(
                    child: requestsController.updateO.value ==
                                requestsController.updateO.value &&
                            requestsController.outgoingRequestsData.isEmpty
                        ? Center(
                            child: Text('outgoingEmpty'.tr),
                          )
                        : ListView.builder(
                            itemCount:
                                requestsController.outgoingRequestsData.length,
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
                                    profileLink: requestsController
                                        .outgoingRequestsData[index]
                                        .user!
                                        .profilePicture,
                                    profileRadius: 17,
                                  ),
                                  title: Text(
                                    requestsController
                                        .outgoingRequestsData[index]
                                        .user!
                                        .displayName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(requestsController
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
                                      requestActionFirebase(
                                          requestsController
                                              .outgoingRequestsData[index].id,
                                          'deny');
                                    },
                                  ),
                                ),
                              );
                            }),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
