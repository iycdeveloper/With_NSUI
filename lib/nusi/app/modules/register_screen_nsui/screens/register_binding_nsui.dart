import 'package:get/get.dart';
import 'package:iyc/nusi/app/modules/login/screens/login_controller_nsui.dart';
import 'package:iyc/nusi/app/modules/register_screen_nsui/screens/register_controller_nsui.dart';

class RegisterNSUIBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterNSUIController());
  }
}