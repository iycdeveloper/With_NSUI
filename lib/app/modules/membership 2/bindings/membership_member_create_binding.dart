import 'package:get/get.dart';
import 'package:iyc/app/modules/membership/controllers/membership_member_create_controller.dart';

class MembershipMemberCreateBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => MembershipMemberCreateController());
  }

}