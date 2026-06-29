import 'package:get/get.dart';
import 'package:iyc/app/modules/ro_access/dashboard/dashboard_controller.dart';

class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }

}