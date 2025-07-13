import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    // Binds the Rx user to the Firebase Auth stream.
    user.bindStream(FirebaseAuth.instance.authStateChanges());
  }
}