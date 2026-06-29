import 'package:get/get.dart';
import 'package:iyc/app/modules/election_report/view_report/view_report_controller.dart';

class ViewReportBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ViewReportController());
  }

}