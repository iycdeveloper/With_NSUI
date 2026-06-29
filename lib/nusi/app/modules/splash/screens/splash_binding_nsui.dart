import 'package:get/get.dart';
import 'package:iyc/nusi/app/modules/splash/screens/splash_controller_nsui.dart';

class SplashNSUIBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SplashNSUIController());
  }
}