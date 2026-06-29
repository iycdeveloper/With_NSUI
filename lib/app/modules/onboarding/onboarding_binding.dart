import 'package:iyc/app/modules/onboarding/onboarding_controller.dart';

import '../../core/app_export.dart';

/// A binding class for the OnboardingScreen.
///
/// This class ensures that the OnboardingController is created when the
/// OnboardingScreen is first loaded.
class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
  }
}