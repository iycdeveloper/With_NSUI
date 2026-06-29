
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/di_container.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 4));
    final sessionId = await LocalStorageServices().getSessionId();
    if (sessionId == "") {
     await DbServices.db.database;
      
      RoutesManagement.goToBoardingScreen();
    } else {
      Log.printILog("current scope is : ${sl.currentScopeName}");
      sl.pushNewScope(
          init: (getIt) async {
            Log.printILog("Current scope changes to ${getIt.currentScopeName}");
            await initIycScope();

            /// re instating deleted tables if not exixt
            await DbServices.db.database;
          },
          scopeName: "iyc_scope",
          dispose: () {
            Log.printILog(
                "................................on dispose scope: ${sl.currentScopeName}");
          });
      RoutesManagement.goToHomeScreen();
    }
  }
}
