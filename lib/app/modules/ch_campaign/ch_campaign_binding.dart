import 'package:get/get.dart';
import 'package:iyc/app/modules/ch_campaign/ch_campaign_controller.dart';

class ChCampaignBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ChCampaignController());
  }
}