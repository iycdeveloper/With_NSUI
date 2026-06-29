import 'package:get/get.dart';
import 'package:iyc/app/modules/report_campaign/campaign_report_controller.dart';

class CampaignReportBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CampaignReportController());
    // TODO: implement dependencies
  }

}