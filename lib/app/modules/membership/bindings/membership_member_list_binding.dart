import 'package:get/get.dart';
import 'package:iyc/app/modules/membership/controllers/membership_member_list_controller.dart';

class MembershipMemberListBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => MembershipMemberListController());
  }

}