import 'package:iyc/app/modules/login/login_controller.dart';
import 'package:iyc/app/modules/onboarding/onboarding_controller.dart';

import '../../core/app_export.dart';

/// A binding class for the LoginScreen.
///
/// This class ensures that the LoginController is created when the
/// LoginScreen is first loaded.
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}