import 'package:get/get.dart';
import 'package:iyc/app/modules/update/update_controller.dart';

class UpdateBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<UpdateController>(() => UpdateController());
  }

}