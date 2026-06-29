import 'package:get/get.dart';
import 'package:iyc/app/modules/rewards/rewards_controller.dart';

class RewardsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RewardsController());
  }

}