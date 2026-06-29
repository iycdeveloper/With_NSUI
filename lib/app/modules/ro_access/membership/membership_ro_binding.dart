import 'package:get/get.dart';
import 'package:iyc/app/modules/ro_access/membership/membership_ro_controller.dart';

class MembershipRoBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => MemberShipRoController());
  }

}