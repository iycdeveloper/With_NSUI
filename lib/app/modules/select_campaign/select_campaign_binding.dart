import 'package:get/get.dart';
import 'package:iyc/app/modules/select_campaign/select_campaign_controller.dart';

class SelectCampaignBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SelectCampaignController());
  }

}