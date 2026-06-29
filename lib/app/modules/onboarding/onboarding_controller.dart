import 'package:get/get.dart';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/app/routes/routes_management.dart';


/// A controller class for the OnboardingScreen.
///
/// This class manages the state of the OnboardingScreen, including the
/// current onboardingModelObj
class OnboardingController extends GetxController {

  @override
  void onInit() async {
    super.onInit();
  }

  void onClickGetStarted(){
    Log.printILog("Navigating to Login Screen");
    RoutesManagement.goToLoginScreen();
  }

}
