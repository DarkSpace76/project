import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/components/bg_widget.dart';
import 'package:project/components/button.dart';
import 'package:project/components/card.dart';
import 'package:project/components/style_title_form.dart';
import 'package:project/screens/gallery/gallery.dart';
import 'package:project/server/auth.dart';
import 'package:project/styles/colors.dart';
import 'package:project/utils/app_text.dart';
import 'package:project/utils/const.dart';
import 'package:project/utils/utils.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _regFormKey = GlobalKey<FormState>();
  bool _isValideForm = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pasController = TextEditingController();
  final TextEditingController pasConfController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.addListener(_checkInputs);
    emailController.addListener(_checkInputs);
    pasController.addListener(_checkInputs);
    pasConfController.addListener(_checkInputs);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    pasController.dispose();
    pasConfController.dispose();
    super.dispose();
  }

  void _checkInputs() {
    final inputFields = [
      nameController.text,
      emailController.text,
      pasController.text,
      pasConfController.text,
    ];

    final res = inputFields.every((field) => field.isNotEmpty);
    if (res) {
      setState(() {
        _isValideForm = res;
      });
    }
  }

  void toNextForm() {
    if (_regFormKey.currentState!.validate()) {
      if (pasController.text == pasConfController.text) {
        AuthorizationService.instance
            .createUserWithEmailAndPassword(
              emailController.text,
              pasConfController.text,
            )
            .then((credential) {
              Get.to(GalleryScreen());
            });
      } else {
        Get.snackbar(
          'Регистрация',
          'Пароли не совпадают',
          colorText: appbarColorTitle,
        );
      }
    } else {
      print('Error in the registration form data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Form(
            key: _regFormKey,
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
                        styleTitleForm(title: titleRegForm),
                        card(
                          controller: nameController,
                          title: titleRegName,
                          hint: hintname,
                        ),
                        card(
                          controller: emailController,
                          title: titlePass,
                          hint: hintRegEmail,
                          keyboardType: TextInputType.emailAddress,
                          validator: emailValidator,
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 5),
                          child: Divider(
                            height: 0.5,
                            color: Color.fromRGBO(64, 64, 64, 1),
                          ),
                        ),
                        card(
                          controller: pasController,
                          title: titleRegPass,
                          hint: hintRegPass,
                          obscureText: true,
                          validator: passwordValidator,
                        ),
                        card(
                          controller: pasConfController,
                          title: titleRegConfPass,
                          hint: hintRegPass,
                          obscureText: true,
                          validator: passwordValidator,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  if (!_isValideForm)
                    fillButton(caption: titleBtnRed)
                  else
                    gradientButton(caption: titleBtnRed, onPress: toNextForm),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
