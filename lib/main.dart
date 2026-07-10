import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iyc/app/core/utils/http_overrides.dart';
import 'package:iyc/app/routes/app_pages.dart';
import 'package:iyc/firebase_options.dart';
// import 'package:iyc/helper/dynamic_link_helper.dart';
import 'package:iyc/utils/my_notification.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app/core/app_export.dart';
import 'package:iyc/di_container.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'IYC',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await DynamicLinkService().initDynamicLinks();

  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);

  // Route synchronous Flutter framework errors to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // Route uncaught async/platform errors to Crashlytics.
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  HttpOverrides.global = MyHttpOverrides();
  await di.init();
  runApp(const MyApp());
  try {
    await FirebaseMessaging.instance.requestPermission(
        provisional: true, sound: true, badge: true, alert: true);
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    await MyNotification.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    _getStoragePermission();
    // await IycDbServices.db.initDB();
  } catch (e, stack) {
    FirebaseCrashlytics.instance.recordError(e, stack);
  }
}

Future _getStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    Log.printILog("Storage permission granted");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        translations: AppLocalization(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
        title: 'iyc',
        initialBinding: InitialBindings(),
        initialRoute: AppRoutes.splashscreeNSUI,
        getPages: AppPages.pages,
        // navigatorObservers: [FirebaseAnalyticsService().appAnalyticsObserver()],
      ),
    );
  }
}
