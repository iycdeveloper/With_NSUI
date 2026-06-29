import 'package:get/get.dart';
import 'package:iyc/app/modules/scrutiny/scrutiny_controller.dart';

class ScrutinyBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ScrutinyController());
  }

}