import 'package:flutter/material.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';class SplashProvider extends ChangeNotifier{
  SplashProvider(){
    //constructor call
    checkLoginStatus();
  }
bool isLoading=true;
late bool isLogin;
  checkLoginStatus()async{
    await LocalStorageServices().getSessionId().then((value) {
      if(value==""){
        isLogin=false;
      }
      else{
        isLogin=true;
      }
      isLoading=false;
      notifyListeners();
    });
  }
}