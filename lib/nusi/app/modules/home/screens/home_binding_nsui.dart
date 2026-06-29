import 'package:get/get.dart';
import 'package:iyc/nusi/app/modules/home/screens/home_controller_nsui.dart';

class HomeNSUIBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomeNSUIController());
  }
}