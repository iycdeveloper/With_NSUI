import 'package:get/get.dart';
import 'package:iyc/app/modules/contributions/contributions_controller.dart';

class ContributionsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ContributionsController());
  }

}