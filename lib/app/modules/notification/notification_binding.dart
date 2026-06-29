import 'package:get/get.dart';
import 'package:iyc/app/modules/notification/notification_controller.dart';

class NotificationBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController());
  }

}