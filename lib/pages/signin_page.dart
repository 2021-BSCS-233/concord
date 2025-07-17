import 'package:concord/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:concord/widgets/input_field.dart';
import 'package:concord/controllers/sign_in_controller.dart';

class SignInPage extends StatelessWidget {
  final SignInController signInController = Get.put(SignInController());

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Create Account',
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
                    'Welcome To Concord!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const Text('We\'re excited to see you join us!'),
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
                    fieldLabel: 'Username',
                    controller: signInController.signInUsernameTC,
                    fieldRadius: 2,
                    horizontalMargin: 0,
                    verticalMargin: 2,
                    fieldHeight: 50,
                    contentTopPadding: 13,
                    suffixIcon: Icons.all_inclusive,
                    maxLength: 20,
                  ),
                  CustomInputField(
                    fieldLabel: 'Display Name',
                    controller: signInController.signInDisplayTC,
                    fieldRadius: 2,
                    horizontalMargin: 0,
                    verticalMargin: 2,
                    fieldHeight: 50,
                    contentTopPadding: 13,
                    suffixIcon: Icons.all_inclusive,
                  ),
                  CustomInputField(
                    fieldLabel: 'Email',
                    controller: signInController.signInEmailTC,
                    fieldRadius: 2,
                    horizontalMargin: 0,
                    verticalMargin: 2,
                    fieldHeight: 50,
                    contentTopPadding: 13,
                    suffixIcon: Icons.all_inclusive,
                  ),
                  Obx(() => CustomInputField(
                        fieldLabel: 'Password',
                        controller: signInController.signInPassTC,
                        fieldRadius: 2,
                        horizontalMargin: 0,
                        verticalMargin: 2,
                        fieldHeight: 50,
                        contentTopPadding: 13,
                        hidden: signInController.hidePassword.value,
                        hideLetters: () {
                          signInController.hidePassword.value =
                              !(signInController.hidePassword.value);
                        },
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () async {
                      var response = await signInController.sendSignIn();
                      if (response) {
                        Get.delete<SignInController>();
                        Get.delete<LogInController>();
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
                        'Sign In',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: signInController.showWaitOverlay.value,
              child: Container(
                color: const Color(0xC01D1D1F),
                child: const Center(child: CircularProgressIndicator()),
              ),
            )),
      ],
    );
  }
}
