import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:concord/main.dart';
import 'package:get/get.dart';
import 'package:concord/widgets/input_field.dart';
import 'package:concord/services/page_controllers.dart';
import 'package:concord/services/firebase_services.dart';

class SignIn extends StatelessWidget {
  final SignInController signInController = Get.put(SignInController());

  SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
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
                  Text(
                    'Welcome To Concord!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Text('We\'re excited to see you join us!'),
                  const SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: const EdgeInsets.only(left: 5, bottom: 5),
                        child: Text(
                          'ACCOUNT INFORMATION',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        )),
                  ),
                  InputField(
                    fieldLabel: 'Username',
                    controller: signInController.signInUsernameController,
                    fieldRadius: 2,
                    horizontalMargin: 0,
                    verticalMargin: 2,
                    fieldHeight: 50,
                    contentTopPadding: 13,
                    suffixIcon: Icons.all_inclusive,
                    maxLength: 20,
                  ),
                  InputField(
                    fieldLabel: 'Display Name',
                    controller: signInController.signInDisplayController,
                    fieldRadius: 2,
                    horizontalMargin: 0,
                    verticalMargin: 2,
                    fieldHeight: 50,
                    contentTopPadding: 13,
                    suffixIcon: Icons.all_inclusive,
                  ),
                  InputField(
                    fieldLabel: 'Email',
                    controller: signInController.signInEmailController,
                    fieldRadius: 2,
                    horizontalMargin: 0,
                    verticalMargin: 2,
                    fieldHeight: 50,
                    contentTopPadding: 13,
                    suffixIcon: Icons.all_inclusive,
                  ),
                  InputField(
                    fieldLabel: 'Password',
                    controller: signInController.signInPassController,
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
                      signInController.showOverlaySignIn.value = true;
                      var userData = await signInController.sendSignIn(
                          signInController.signInUsernameController.text.trim(),
                          signInController.signInDisplayController.text.trim(),
                          signInController.signInEmailController.text.trim(),
                          signInController.signInPassController.text.trim());
                      if (userData != 0) {
                        await saveUserOnDevice(
                            signInController.signInEmailController.text.trim(),
                            signInController.signInPassController.text.trim());
                        signInController.showOverlaySignIn.value = false;
                        userData[0]['id'] = userData[1].user.uid;
                        Get.delete<SignInController>();
                        Get.offAll(Home(
                          userData: userData[0],
                        ));
                      } else {
                        debugPrint('SingIn failed');
                      }
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent.shade700,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Center(child: Text('Sign In')),
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
                visible: signInController.showMessageSignIn.value,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: signInController.messageHeightSignIn,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Color(0xFF121218),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('SignIn Failed',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 5),
                        Text(signInController.failMessage,
                            // textAlign: TextAlign.center,
                            style: TextStyle(
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
                            decoration: BoxDecoration(
                                color: Colors.blueAccent.shade700,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
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
