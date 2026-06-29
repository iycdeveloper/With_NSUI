import 'package:get/get.dart';
import 'package:iyc/app/modules/membership/controllers/membership_member_view_controller.dart';

class MembershipMemberViewBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => MembershipMemberViewController());
  }

}