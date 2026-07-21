import 'package:get/get.dart';
import 'package:iyc/screens/ui/payment/payment_history/payment_history_controller.dart';

class PaymentHistoryBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentHistoryController());
  }
}