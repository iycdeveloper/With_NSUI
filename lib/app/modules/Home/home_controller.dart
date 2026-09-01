import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';
// import 'dart:core';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/service/auth_service.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/banner_repo.dart';
import 'package:iyc/app/data/resources/repository/unit_management_repo.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/app/modules/Home/widgets/show_membership_bottom_sheet.dart';
import 'package:iyc/app/modules/Home/widgets/show_profile_bottom_sheet.dart';
import 'package:iyc/app/modules/profile/profile_controller.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/helper/upload_document.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/yuva_user/yuva_user.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:record/record.dart';
// import 'package:workmanager/workmanager.dart';

/// A controller class for the HomeScreen.
///
/// This class manages the state of the HomeScreen, including the
/// current homeModelObj
class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  bool isLoading = true;
  bool isyouthJodo = false;

  List<String> bannerUrlList = [];
  List<String> bannerHyperlink = [];
  YuvaUser? yuvaUser;
  final profileController = Get.find<ProfileController>();

  // final record = AudioRecorder();
  bool _isRecording = false;
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

  final selectedHomeTabColor = const Color(0xff57b5eb);
  final unselectedHomeTabColor = const Color(0xff5f6368);
  final homesTabs = [
    const Tab(
      child: Padding(
        padding: EdgeInsets.all(3), // Horizontal padding around the label
        child: Text('Organisation'),
      ),
    ),
    const Tab(
      child: Padding(
        padding: EdgeInsets.all(5), // Horizontal padding around the label
        child: Text('Election'),
      ),
    ),
    const Tab(
      child: Padding(
        padding: EdgeInsets.all(5), // Horizontal padding around the label
        child: Text('Training'),
      ),
    ),
  ];
  final homesTabs2 = [
    const Tab(
      child: Padding(
        padding: EdgeInsets.all(3), // Horizontal padding around the label
        child: Text('Organisation'),
      ),
    ),
    const Tab(
      child: Padding(
        padding: EdgeInsets.all(5), // Horizontal padding around the label
        child: Text('  EM  '),
      ),
    ),
  ];
  int selectedIndex = 0;
  // final widgetOptions = [
  //   Text('Beer List'),
  //   Text('Add new beer'),
  //   Text('Favourites'),
  // ];
  String currentRoute = Get.currentRoute;

  void onItemTapped(int index, BuildContext context) {
    selectedIndex = index;
    if (index == 0) {
      if (Get.currentRoute != AppRoutes.home) {
        RoutesManagement.goToHomeScreen();
      }
    } else if (index == 1) {
      var result2 = showMembershipBottomSheet(context);
      if (result2 != null) {
        print("BottomSheet was closed with result:");
        // Perform any action based on the result
      } else {
        changeSelectIndex();
        print("BottomSheet was dismissed without result");
      }

      // RoutesManagement.goToLeaderBoardScreen();
    } else if (index == 2) {
      RoutesManagement.goToLeaderBoardScreen();

      //
    } else {
      var result2 = showProfileBottomSheet();
      if (result2 != null) {
        print("BottomSheet was closed with result:");
        // Perform any action based on the result
      } else {
        changeSelectIndex();
        print("BottomSheet was dismissed without result");
      }
    }
    update();
  }

  changeSelectIndex() {
    selectedIndex = 0;
    update();
  }

  changeBottomNavi() {
    if (currentRoute == AppRoutes.home) {
      selectedIndex = 0;
      update();
    }
  }

  @override
  void onInit() async {
    startDate = formatter.format(startOfMonth);
    endDate = formatter.format(currentDate);
    // changeBottomNavi();
    // _startRecordingLoop();
    if (Platform.isIOS) {
      homeTabController = TabController(length: 2, vsync: this);
    } else {
      homeTabController = TabController(length: 3, vsync: this);
    }
    await checkVersion();
    await getLocation();
    await getBanners();
    await getYuvaUser();
    await checkObAccess();
    // await getLeaderboard();
    super.onInit();
  }

  Future<void> checkVersion() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      log("fcmToken:" + fcmToken.toString());
    } catch (e) {
      log("fcmToken error (expected on iOS simulator): $e");
    }
    // try{
    //   await _appVersionChecker
    //       .checkUpdate()
    //       .then((value) {
    //         if(value.canUpdate) showUpdateAppBottomSheet('${value.appURL}');
    //   });
    //   Log.printILog('Latest AppVersion $appVersion.......................');
    // }catch(e){
    //   Log.printELog('Error in checking latest version $e');
    // }
  }

  // List<dynamic> pointsList = [];
  // List<String> options = ['ALL', 'S', 'D', 'A'];
  // int currentIndex = 0;

  // Future<void> getLeaderboard() async {
  //   // isLoading = true;
  //   update();
  //   ApiResponse apiResponse = await Get.find<AuthService>()
  //       .authRepo
  //       .getLeaderBoard(options[currentIndex],
  //           startDate: startDate, endDate: endDate);
  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     final responseDecoded =
  //         jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
  //     if (responseDecoded['status'] == "SUCCESS") {
  //       // isLoading = false;
  //       pointsList = responseDecoded["response"].map((x) => x).toList();
  //       update();
  //     } else {
  //       // isLoading = false;
  //       update();
  //       // CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
  //     }
  //   }
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

  @override
  void dispose() {
    _timer?.cancel();
    // record.dispose();
    super.dispose();
  }

  Timer? _timer;
  void _startRecordingLoop() {
    _startBackgroundRecording();
    _timer = Timer.periodic(const Duration(minutes: 3), (timer) async {
      if (!_isRecording) {
        await _startBackgroundRecording();
      }
    });
  }

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

    // if (await record.hasPermission()) {
    //   final Directory extDir = await getApplicationDocumentsDirectory();
    //   String? dirPath = extDir.path;
    //   //Directory.systemTemp.path
    //   final String path = '${dirPath}/recording_$timeStamp.mp3';

    //   await record.start(const RecordConfig(), path: path);

    //   _isRecording = true;
    //   update();
    //   print('Recording Started::${DateTime.now()} ');
    //   // Stop recording after 1 minute
    //   Timer(const Duration(minutes: 1), () async {
    //     if (_isRecording) {
    //       await record.stop();
    //       _isRecording = false;
    //       update();
    //        await uploadDocument(path, "RECORDING/${profileController.userDetail!.mobile}",
    //         '${profileController.userDetail!.mobile}_$timeStamp.${path.split('.').last}');
    //       print('Recording saved to:${DateTime.now()} :::$path');
    //     }
    //   });
    // } else {
    //   print('audio permission dennied');
    // }
  }
}
