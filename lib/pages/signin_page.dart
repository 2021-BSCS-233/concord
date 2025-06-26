import 'package:flutter/material.dart';
import 'package:concord/main.dart';
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
                    controller: signInController.signInUsernameTextController,
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
                    controller: signInController.signInDisplayTextController,
                    fieldRadius: 2,
                    horizontalMargin: 0,
                    verticalMargin: 2,
                    fieldHeight: 50,
                    contentTopPadding: 13,
                    suffixIcon: Icons.all_inclusive,
                  ),
                  CustomInputField(
                    fieldLabel: 'Email',
                    controller: signInController.signInEmailTextController,
                    fieldRadius: 2,
                    horizontalMargin: 0,
                    verticalMargin: 2,
                    fieldHeight: 50,
                    contentTopPadding: 13,
                    suffixIcon: Icons.all_inclusive,
                  ),
                  Obx(() => CustomInputField(
                        fieldLabel: 'Password',
                        controller: signInController.signInPassTextController,
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
                        Get.deleteAll();
                        Get.offAll(Home());
                      } else {
                        debugPrint('SingIn failed');
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
              visible: signInController.showOverlaySignIn.value ||
                  signInController.showMessageSignIn.value,
              child: GestureDetector(
                onTap: signInController.showMessageSignIn.value
                    ? () {
                        signInController.showMessageSignIn.value = false;
                        signInController.showOverlaySignIn.value = false;
                        signInController.messageHeightSignIn = 250;
                        signInController.failMessage = '';
                      }
                    : () {},
                child: Container(
                  color: const Color(0xC01D1D1F),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            )),
        Obx(() => Material(
              color: Colors.transparent,
              child: Visibility(
                visible: signInController.showMessageSignIn.value,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: signInController.messageHeightSignIn,
                    width: 300,
                    decoration: const BoxDecoration(
                        color: Color(0xFF121218),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('SignIn Failed',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 5),
                        Text(signInController.failMessage,
                            // textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 35),
                        InkWell(
                          onTap: () {
                            signInController.showMessageSignIn.value = false;
                            signInController.showOverlaySignIn.value = false;
                            signInController.messageHeightSignIn = 250;
                            signInController.failMessage = '';
                          },
                          child: Container(
                            height: 50,
                            width: 130,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 255, 77, 0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: const Center(
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
