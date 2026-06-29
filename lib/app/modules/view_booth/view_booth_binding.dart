import 'package:get/get.dart';
import 'package:iyc/app/modules/view_booth/view_booth_controller.dart';

class ViewBoothBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ViewBoothController());
  }

}