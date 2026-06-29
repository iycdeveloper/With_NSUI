import 'package:get/get.dart';
import 'package:iyc/app/modules/nyay_guarantee_ml/nyay_guarantee_controller.dart';

class NyayGuaranteeMlBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => NyayGuaranteeMlController());
  }
}