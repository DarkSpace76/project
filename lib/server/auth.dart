import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:project/screens/auth/auth.dart';

class AuthorizationService {
  static late AuthorizationService instance;

  AuthorizationService() {
    instance = this;
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
    String emailAddress,
    String password,
  ) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Регистрация', 'Указанный пароль слишком слабый.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
          'Регистрация',
          'Учетная запись для этого электронного письма уже существует.',
        );
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<UserCredential?> signInWithEmailAndPassword(
    String emailAddress,
    String password,
  ) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      print(e);
    }
    return null;
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.off(AuthScreen());
  }

  void saveParams() {}
}
