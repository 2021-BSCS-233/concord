import 'package:concord/pages/signin_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:concord/main.dart';
import 'package:get/get.dart';
import 'package:concord/widgets/input_field.dart';
import 'package:concord/services/page_controllers.dart';
import 'package:concord/services/firebase_services.dart';

class LogIn extends StatelessWidget {
  final LogInController logInController = Get.put(LogInController());

  LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Log In',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Text('We\'re excited to see you again!'),
                  const SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: EdgeInsets.only(left: 5, bottom: 5),
                        child: Text(
                          'ACCOUNT INFORMATION',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        )),
                  ),
                  InputField(
                    fieldLabel: 'Email',
                    controller: logInController.logInEmailController,
                    fieldRadius: 2,
                    horizontalMargin: 0,
                    verticalMargin: 2,
                    fieldHeight: 50,
                    contentTopPadding: 13,
                    suffixIcon: Icons.all_inclusive,
                  ),
                  InputField(
                    fieldLabel: 'Password',
                    controller: logInController.logInPassController,
                    fieldRadius: 2,
                    horizontalMargin: 0,
                    verticalMargin: 2,
                    fieldHeight: 50,
                    contentTopPadding: 13,
                    suffixIcon: CupertinoIcons.eye,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () async {
                      logInController.showOverlayLogIn.value = true;
                      var userData = await logInController.sendLogIn(
                          logInController.logInEmailController.text.trim(),
                          logInController.logInPassController.text.trim());
                      if (userData != 0) {
                        await saveUserOnDevice(
                            logInController.logInEmailController.text.trim(),
                            logInController.logInPassController.text.trim());
                        logInController.showOverlayLogIn.value = false;
                        userData[0]['id'] = userData[1].user.uid;
                        Get.delete<LogInController>();
                        Get.offAll(Home(
                          userData: userData[0],
                        ));
                      } else {
                        logInController.showOverlayLogIn.value = true;
                        logInController.showMessageLogIn.value = true;
                      }
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent.shade700,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Center(child: Text('Log In')),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  InkWell(
                    enableFeedback: false,
                    onTap: () {
                      Get.to(SignIn());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Create Account',
                            style: TextStyle(color: Colors.blueAccent.shade200),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: logInController.showOverlayLogIn.value ||
                  logInController.showMessageLogIn.value,
              child: GestureDetector(
                onTap: logInController.showMessageLogIn.value
                    ? () {
                        logInController.showOverlayLogIn.value = false;
                        logInController.showMessageLogIn.value = false;
                      }
                    : () {},
                child: Container(
                  color: Color(0xC01D1D1F),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            )),
        Obx(() => Material(
              color: Colors.transparent,
              child: Visibility(
                visible: logInController.showMessageLogIn.value,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Color(0xFF121218),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('LogIn Failed',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 5),
                        Text('Email or Password is Wrong',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 35),
                        InkWell(
                          onTap: () {
                            logInController.showMessageLogIn.value = false;
                            logInController.showOverlayLogIn.value = false;
                          },
                          child: Container(
                            height: 50,
                            width: 130,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent.shade700,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Center(
                              child: Text(
                                'Close',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
