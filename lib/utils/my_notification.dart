import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'app_constants.dart';

class MyNotification {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('launcher_icon');
    var iOSInitialize = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse? payload) async {
      try {
        if (payload != null) {
          // MyApp.navigatorKey.currentState.push(MaterialPageRoute( builder: (context) => OrderDetailsScreen(
          // orderModel: null, orderId: int.parse(payload))));
        }
        return;
      } catch (e) {}
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      MyNotification.showNotification(
          message.notification, flutterLocalNotificationsPlugin);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Log.printELog("onMessage: ${message.notification}");
      print("onMessageApp: ${message.data}");
    });
  }

  static Future<void> showNotification(
      RemoteNotification? message, FlutterLocalNotificationsPlugin fln) async {
    if (message!.android!.imageUrl != null &&
        message.android!.imageUrl!.isNotEmpty) {
      try {
        await showBigPictureNotificationHiddenLargeIcon(message, fln);
      } catch (e) {
        await showBigTextNotification(message, fln);
      }
    } else {
      await showBigTextNotification(message, fln);
    }
  }

  static Future<void> showTextNotification(
      Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    String _title = message['title'];
    String _body = message['body'];
    // String _orderID = message['order_id'];
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'big text channel description',
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      playSound: true,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, _title, _body, platformChannelSpecifics, payload: null);
  }

  static Future<void> showBigTextNotification(
      RemoteNotification? message, FlutterLocalNotificationsPlugin fln) async {
    String _title = message!.title!;
    String _body = message.body!;
    // String? _orderID = message['order_id'];
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      _body,
      htmlFormatBigText: true,
      contentTitle: _title,
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
      channelDescription: 'big text channel description',
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.high,
      icon: 'launcher_icon',

      // playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    int notificationId = 0; // Default value in case null is passed

    if (message != null && message.android!.channelId != null) {
      notificationId = int.tryParse(message.android!.channelId!) ?? 0;
      print('channelid:' + notificationId.toString());
    }
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(
      888,
      _title,
      _body,
      platformChannelSpecifics,
    );
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      RemoteNotification? message, FlutterLocalNotificationsPlugin fln) async {
    String _title = message!.title!;
    String _body = message.body!;
    // String _orderID = message['order_id'];
    String _image = message.android!.imageUrl!.startsWith('http')
        ? message.android!.imageUrl!
        : '${AppConstants.channel}/storage/app/public/notification/${message.android!.imageUrl!}';
    final String largeIconPath =
        await _downloadAndSaveFile(_image, 'largeIcon');
    final String bigPicturePath =
        await _downloadAndSaveFile(_image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: _title,
      htmlFormatContentTitle: true,
      summaryText: _body,
      htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
      channelDescription: 'big text channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      priority: Priority.high,
      sound: const RawResourceAndroidNotificationSound('notification'),
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, _title, _body, platformChannelSpecifics, payload: null);
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final Response response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print('background: ${message.data}');
}
