import 'package:get/get.dart';
import 'package:iyc/app/modules/check-in/check_in_controller.dart';

class CheckInBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CheckInController());
  }

}