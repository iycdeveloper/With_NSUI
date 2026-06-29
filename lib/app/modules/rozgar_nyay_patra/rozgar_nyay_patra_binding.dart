import 'package:get/get.dart';
import 'package:iyc/app/modules/rozgar_nyay_patra/rozgar_nyay_patra_controller.dart';

class RozgarNyayPatraBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<RozgarNyayPatraController>(() => RozgarNyayPatraController());
  }

}