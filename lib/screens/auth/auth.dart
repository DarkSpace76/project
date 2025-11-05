import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/components/bg_widget.dart';
import 'package:project/components/button.dart';
import 'package:project/components/card.dart';
import 'package:project/components/style_title_form.dart';
import 'package:project/screens/auth/controller/auth_controller.dart';
import 'package:project/screens/registration/registratoion.dart';
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

  void toAuth() {
    if (_authKeyForm.currentState!.validate()) {
      //todo
    } else {
      print('Ошибка формы регистрации');
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
                          title: titleEmail,
                          hint: hintAuthEmail,
                          keyboardType: TextInputType.emailAddress,
                          validator: emailValidator,
                        ),
                        card(
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
