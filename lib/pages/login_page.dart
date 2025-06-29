import 'package:concord/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:concord/main.dart';
import 'package:get/get.dart';
import 'package:concord/widgets/input_field.dart';
import 'package:concord/controllers/login_controller.dart';

class LogInPage extends StatelessWidget {
  final LogInController logInController = Get.put(LogInController());

  LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
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
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const Text('We\'re excited to see you again!'),
                  const SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: const EdgeInsets.only(left: 5, bottom: 5),
                        child: const Text(
                          'ACCOUNT INFORMATION',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        )),
                  ),
                  CustomInputField(
                    fieldLabel: 'Email',
                    controller: logInController.logInEmailTextController,
                    fieldRadius: 2,
                    horizontalMargin: 0,
                    verticalMargin: 2,
                    fieldHeight: 50,
                    contentTopPadding: 13,
                    suffixIcon: Icons.all_inclusive,
                  ),
                  Obx(() => CustomInputField(
                        fieldLabel: 'Password',
                        controller: logInController.logInPassTextController,
                        fieldRadius: 2,
                        horizontalMargin: 0,
                        verticalMargin: 2,
                        fieldHeight: 50,
                        contentTopPadding: 13,
                        hidden: logInController.hidePassword.value,
                        hideLetters: () {
                          logInController.hidePassword.value =
                              !(logInController.hidePassword.value);
                        },
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () async {
                      bool response = await logInController.sendLogIn();
                      if (response) {
                        Get.delete<LogInController>();
                        Get.offAll(Home());
                      } else {
                        debugPrint('login failed');
                      }
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 77, 0),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: const Center(
                          child: Text(
                        'Log In',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      enableFeedback: false,
                      onTap: () {
                        Get.to(SignInPage());
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                        child: Text(
                          'Create Account',
                          style:
                              TextStyle(color: Color.fromARGB(255, 255, 77, 0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: logInController.showOverlayLogIn.value,
              child: Container(
                color: const Color(0xC01D1D1F),
                child: const Center(child: CircularProgressIndicator()),
              ),
            )),
      ],
    );
  }
}
