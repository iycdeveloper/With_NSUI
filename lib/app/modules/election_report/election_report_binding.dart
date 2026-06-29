import 'package:get/get.dart';
import 'package:iyc/app/modules/election_report/election_report_controller.dart';

class ElectionReportBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ElectionReportController());
  }

}