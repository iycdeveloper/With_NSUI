import 'package:get/get.dart';
import 'package:iyc/nusi/app/modules/social/screens/social_controller_nsui.dart';

class SocialNSUIBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SocialNSUIController());
  }
}