import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:project/screens/registration/registratoion.dart';

class AuthController extends GetxController {
  void toRegForm() {
    Get.to(RegistrationScreen());
  }
}
