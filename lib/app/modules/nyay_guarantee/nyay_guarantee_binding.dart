import 'package:get/get.dart';
import 'package:iyc/app/modules/nyay_guarantee/nyay_guarantee_controller.dart';

class NyayGuaranteeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => NyayGuaranteeController());
  }
}