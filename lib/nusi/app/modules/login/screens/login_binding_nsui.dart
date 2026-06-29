import 'package:get/get.dart';
import 'package:iyc/nusi/app/modules/login/screens/login_controller_nsui.dart';

class LoginNSUIBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LoginNSUIController());
  }
}