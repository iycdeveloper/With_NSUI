import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/service/auth_service.dart';
import 'package:iyc/app/core/service/internet_connection_service.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
    // Get.put(InternetConnectionService(), permanent: true);

  }
}
