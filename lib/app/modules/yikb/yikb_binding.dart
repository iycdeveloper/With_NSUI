import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/yikb/yikb_controller.dart';

class YIKBBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => YIKBController());
  }

}