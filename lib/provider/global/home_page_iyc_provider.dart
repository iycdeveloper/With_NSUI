import 'package:flutter/cupertino.dart';
import 'package:iyc/provider/auth/auth_api_provider.dart';
import 'package:provider/src/provider.dart';

import '../../di_container.dart';
import 'location_provider.dart';

class HomePageIycProvider extends ChangeNotifier {
  bool isLoading = false;
  bool showLocationError = false;

  getLocation(BuildContext context, {bool isRefresh = false}) async {
    // await Future.delayed(Duration.zero);
    await context.read<AuthApiProvider>().dobRange(context: context);
    if (sl<LocationProvider>().currentLocation != null) {
      return true;
    }
    showLocationError = false;
    isLoading = true;
    if (isRefresh) notifyListeners();
    try {
      sl<LocationProvider>().currentLocation ??
          await sl<LocationProvider>().setInitialLocationOnLogin(context);
    } on Exception catch (e) {
      // TODO
    }
    if (sl<LocationProvider>().currentLocation != null) {
      isLoading = false;
      showLocationError = false;
      notifyListeners();
    } else {
      showLocationError = true;
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    print("home page iyc provider dispose ");
    super.dispose();
  }
}
