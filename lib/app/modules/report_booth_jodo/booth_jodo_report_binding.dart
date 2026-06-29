import 'package:get/get.dart';
import 'package:iyc/app/modules/report_booth_jodo/booth_jodo_report_controller.dart';

class BoothJodoReportBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => BoothJodoReportController());
  }

}