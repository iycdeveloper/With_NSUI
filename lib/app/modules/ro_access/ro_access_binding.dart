import 'package:get/get.dart';
import 'package:iyc/app/modules/ro_access/ro_access_controller.dart';

class ROAccessBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ROAccessController());
  }

}