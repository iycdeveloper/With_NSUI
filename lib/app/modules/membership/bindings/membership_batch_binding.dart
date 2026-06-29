import 'package:get/get.dart';
import 'package:iyc/app/modules/membership/controllers/membership_batch_controller.dart';

class MembershipBatchBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => MembershipBatchController());
  }

}