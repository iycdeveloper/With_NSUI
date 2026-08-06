import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/nusi/app/modules/profile/screens/profile_controller_nsui.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:core';
// import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/service/auth_service.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/banner_repo.dart';
import 'package:iyc/app/data/resources/repository/unit_management_repo.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/yuva_user/yuva_user.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeNSUIController extends GetxController
    with GetSingleTickerProviderStateMixin {
  @override
  void onInit() {
    super.onInit();
    initmethod();
    motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    motionTabBarController!.dispose();
    // _timer?.cancel();
    super.dispose();
  }

  MotionTabBarController? motionTabBarController;
  var selectedTabIndex = 0.obs;

  void onchangeMenu(int index) {
    selectedTabIndex.value = index;
    motionTabBarController!.index = index;
    update();
  }

  onchangeMenuold(int value) {
    motionTabBarController!.index = value;
    // if (value == 0) {
    //   RoutesManagement.goToHomeScreenNSUI();
    // } else if (value == 1) {
    //   RoutesManagement.goToSocialScreenNSUI();
    // } else {
    //   RoutesManagement.goToProfileScreenNSUI();
    // }
    // update();
  }

  FloatingActionButtonLocation floatingActionButtonLocation =
      FloatingActionButtonLocation.startDocked;
  initmethod() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    log("fcmToken:" + fcmToken.toString());

    await getLocation();
    await Future.delayed(const Duration(seconds: 2));
    isLoading = false;
    update();
  }

  bool isLoading = true;
  bool isyouthJodo = false;

  List<String> bannerUrlList = [];
  List<String> bannerHyperlink = [];
  YuvaUser? yuvaUser;
  final profileController = Get.put(ProfileNSUIController());
  String maskMobileNumber(String mobileNumber) {
    if (mobileNumber.length < 10) return mobileNumber;

    final visibleStart = mobileNumber.substring(0, 3);
    final visibleEnd = mobileNumber.substring(mobileNumber.length - 3);
    final hidden = '*' * (mobileNumber.length - 6);

    return '$visibleStart$hidden$visibleEnd';
  }
  // final record = AudioRecorder();
  // bool _isRecording = false;
  // final MyActivityController myActivitycontroller = Get.find();

  // final menuController = Get.find<AppMenuController>();
  // final myactivityController = Get.find<MyActivityController>();

  int bannerIndex = 0;
  // final _appVersionChecker = AppVersionChecker(appId: "com.brighterindia.iyc");
  String? appVersion;
  late TabController homeTabController;
  int selectedTabbar = 0;

  onchangeTab(int val) {
    selectedTabbar = val;
    update();
  }

  DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime currentDate = DateTime.now();
  DateTime startOfMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  String startDate = '';
  String endDate = '';

  String currentRoute = Get.currentRoute;

  // @override
  // void onInit() async {
  //   startDate = formatter.format(startOfMonth);
  //   endDate = formatter.format(currentDate);
  //   // changeBottomNavi();
  //   // _startRecordingLoop();
  //   if (Platform.isIOS) {
  //     homeTabController = TabController(length: 2, vsync: this);
  //   } else {
  //     homeTabController = TabController(length: 3, vsync: this);
  //   }
  //   await checkVersion();
  //   await getLocation();
  //   await getBanners();
  //   await getYuvaUser();
  //   await checkObAccess();
  //   // await getLeaderboard();
  //   super.onInit();
  // }

  void updateBannerIndex(int index) {
    bannerIndex = index;
    update();
  }

  Future<void> getBanners() async {
    ApiResponse apiResponse = await BannerRepo().getBanners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        bannerUrlList = responseDecoded['response']
            .map<String>((x) => x["image_link"].toString())
            .toList();
        bannerHyperlink = responseDecoded['response']
            .map<String>((x) => x["hyperlink"].toString())
            .toList();
        update();
      } else {
        if (responseDecoded['response'] ==
            'Session invalid.Logout and login again') {
          CustomSnackBar.showSessionInvalidSnackBar();
        }
        Log.printELog(responseDecoded['response']);
      }
    }
  }

  Future<void> getLocation({bool isRefresh = false}) async {
    Log.printILog("Setting initial location");
    await Get.find<AuthService>().dobRange(context: Get.context!);
    if (sl<LocationProvider>().currentLocation != null) {
      return;
    }
    try {
      sl<LocationProvider>().currentLocation ??
          await sl<LocationProvider>().setInitialLocationOnLogin(Get.context!);
    } on Exception catch (e) {
      // TODO
    }
    if (sl<LocationProvider>().currentLocation != null) {
      update();
    } else {}
  }

  chahgeBottom(String type) {
    if (type == "YouthJodo") {
      isyouthJodo = true;
      update();
    }
  }

  Future<void> getYuvaUser() async {
    ApiResponse apiResponse = await YuvaBoothRepo().getYuvaUserNew();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        yuvaUser = yuvaUserFromJson(responseDecoded['response'][0]);
        isLoading = false;
        update();
      } else {
        isLoading = false;
        update();
        Log.printILog(responseDecoded['response']);
        if (responseDecoded['response'] ==
            'App version not supported. Please update from Play\/App Store.') {
          CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
        }
      }
    }
  }

  bool showObAccess = false;
  Future<void> checkObAccess() async {
    ApiResponse apiResponse = await UnitManagementRepo().checkOBAccess();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        showObAccess = true;
      } else {
        showObAccess = false;
        Log.printILog(responseDecoded['response']);
      }
      update();
    }
  }

  // Timer? _timer;
  // void _startRecordingLoop() {
  //   _startBackgroundRecording();
  //   _timer = Timer.periodic(const Duration(minutes: 3), (timer) async {
  //     if (!_isRecording) {
  //       await _startBackgroundRecording();
  //     }
  //   });
  // }

  Future<String?> getDownloadsDirectory() async {
    Directory? directory = Directory("/storage/emulated/0/Download");
    if (await directory.exists()) {
      return directory.path;
    }
    return null;
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      print("Storage permission granted!");
    } else {
      print("Storage permission denied!");
    }
  }

  Future<void> _startBackgroundRecording() async {
    //  await requestStoragePermission();
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
  }
}
