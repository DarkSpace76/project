import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/components/bg_widget.dart';
import 'package:project/components/button.dart';
import 'package:project/components/card.dart';
import 'package:project/components/style_title_form.dart';
import 'package:project/screens/auth/controller/auth_controller.dart';
import 'package:project/screens/gallery/gallery.dart';
import 'package:project/screens/registration/registratoion.dart';
import 'package:project/server/auth.dart';
import 'package:project/styles/colors.dart';
import 'package:project/utils/app_text.dart';
import 'package:project/utils/const.dart';
import 'package:project/utils/utils.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthController controller = Get.put(AuthController());

  final _authKeyForm = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void toAuth() async {
    if (_authKeyForm.currentState!.validate()) {
      try {
        final user = await AuthorizationService.instance
            .signInWithEmailAndPassword(
              emailController.text,
              passController.text,
            );
        if (user != null) {
          Get.to(GalleryScreen());
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar('Вход', 'Пользователь с таким email не найден');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Вход', 'Неверный пароль');
        }
      } catch (e) {
        Get.snackbar('Вход', 'Произошла непредвиденная ошибка');
      } finally {}
    } else {
      print('Registration form error');
    }
  }

  void toRegForm() {
    Get.to(RegistrationScreen());
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Form(
            key: _authKeyForm,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.only(bottom: 30, left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacer(),
                  Container(
                    child: Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        styleTitleForm(title: titleAuthForm),
                        card(
                          controller: emailController,
                          title: titleEmail,
                          hint: hintAuthEmail,
                          keyboardType: TextInputType.emailAddress,
                          validator: emailValidator,
                        ),
                        card(
                          controller: passController,
                          title: titlePass,
                          hint: hintAuthPass,
                          obscureText: true,
                          validator: passwordValidator,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  gradientButton(caption: titleAuthBtn, onPress: toAuth),
                  fillButton(caption: titleRegBtn, onPress: toRegForm),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
