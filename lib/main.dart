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
import 'package:iyc/di_container.dart' as AppVersion;
import 'package:iyc/firebase_options.dart';
// import 'package:iyc/helper/dynamic_link_helper.dart';
import 'package:iyc/utils/my_notification.dart';
import 'package:iyc/utils/notification_store.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app/core/app_export.dart';
import 'package:iyc/di_container.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> recordFlutterError(FlutterErrorDetails details) async {
  FirebaseCrashlytics.instance.recordFlutterError;
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'NSUI',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await DynamicLinkService().initDynamicLinks();

  

  HttpOverrides.global = MyHttpOverrides();
  await di.init();
  runApp(const MyApp());
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);
  try {
    // provisional:false — provisional (quiet) authorization delivers iOS pushes
    // straight to Notification Center with NO banner/sound/badge and never
    // prompts, which is indistinguishable from push being broken. Android
    // ignores the flag, so this only ever hurt iOS.
    await FirebaseMessaging.instance.requestPermission(
        provisional: false, sound: true, badge: true, alert: true);
    // iOS suppresses foreground pushes unless we explicitly opt in.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    // Broadcast topic: every BPCC install subscribes so the Cloud Function can
    // push a "new quiz" notification to all users at once (best-effort).
    // Name is app-specific so the other apps in this Firebase project (which
    // never subscribe to it) can't receive these pushes.
    //
    // iOS: FCM cannot resolve a token or join a topic until APNs has handed the
    // app a device token, and requestPermission returns BEFORE that completes.
    // Without this wait subscribeToTopic throws "APNS token has not been set
    // yet", so iOS never joined bpcc_quiz and missed every quiz push. Android
    // has no APNs dependency and subscribes first try.
    if (Platform.isIOS) {
      for (var i = 0; i < 10; i++) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) break;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    // try {
    //   await FirebaseMessaging.instance.subscribeToTopic('bpcc_quiz');
    // } catch (e) {
    //   // Never swallow this — a failed subscribe means no quiz pushes at all.
    //   debugPrint('[FCM] subscribeToTopic(bpcc_quiz) failed: $e');
    // }
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    await MyNotification.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    // App launched by tapping a notification from a terminated state — persist
    // it to local history (the background isolate may not have captured it).
    try {
      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        await NotificationStore.insert(
          id: initialMessage.messageId,
          title: initialMessage.notification?.title,
          body: initialMessage.notification?.body,
          data: initialMessage.data,
        );
      }
    } catch (_) {}
    _getStoragePermission();
    // await IycDbServices.db.initDB();
  } catch (e) {
    FlutterError.onError = (e) => recordFlutterError(e);
  }
    AppVersion.init();

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
