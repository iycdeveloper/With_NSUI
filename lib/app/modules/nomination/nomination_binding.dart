import 'package:get/get.dart';
import 'package:iyc/app/modules/nomination/nomination_controller.dart';

class NominationBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => NominationController());
  }
}