import 'package:get/get.dart';
import 'package:iyc/nusi/app/modules/profile/screens/profile_controller_nsui.dart';

class ProfileNSUIBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileNSUIController());
  }
}