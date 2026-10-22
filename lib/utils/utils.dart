import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

toPage(BuildContext context, Widget widget, {String? routeSettingName}) {
  return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => widget,
      settings: RouteSettings(name: routeSettingName)));
}

toPagePopAll(BuildContext context, Widget widget, {String? routeSettingName}) {
  return Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
        builder: (context) => widget,
        settings: RouteSettings(name: routeSettingName)),
    (route) => false,
  );
}

toPushNamedAndRemoveUntil(
    {required BuildContext context, required String widgetName}) {
  return Navigator.pushNamedAndRemoveUntil(
      context, widgetName, (Route<dynamic> route) => false);
}

const _secureStorage = FlutterSecureStorage();
const _deviceUuidKey = 'device_uuid';

/// A device identifier that survives uninstall/reinstall, for tracking how
/// many distinct devices a login has been used from.
///
/// - Android: Settings.Secure.ANDROID_ID, scoped to this app's signing key
///   + the device. It survives uninstall/reinstall as long as the app is
///   reinstalled with the same signing key (true for this app's release
///   builds) -- unlike the previous `androidInfo.id`, which is actually
///   `Build.ID` (the firmware/OS build string), identical across every
///   device running the same ROM build and not unique per device at all.
/// - iOS: `identifierForVendor` resets on a full uninstall/reinstall once
///   no other app from this vendor remains, so instead a UUID is generated
///   once and stored in the Keychain via flutter_secure_storage -- Keychain
///   data (unlike UserDefaults/SharedPreferences) survives uninstall.
Future<String> getDeviceIdentifier() async {
  String? deviceIdentifier = "unknown";
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    deviceIdentifier = await const AndroidId().getId();
    deviceIdentifier ??= await _persistedUuid();
  } else if (Platform.isIOS) {
    deviceIdentifier = await _persistedUuid();
  } else if (kIsWeb) {
    // The web doesnt have a device UID, so use a combination fingerprint as an example
    WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
    deviceIdentifier = webInfo.vendor! +
        webInfo.userAgent! +
        webInfo.hardwareConcurrency.toString();
  } else if (Platform.isLinux) {
    LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
    deviceIdentifier = linuxInfo.machineId;
  }
  return deviceIdentifier!;
}

/// Reads the UUID stored in the Keychain, generating and persisting one on
/// first call. Used for iOS, and as the Android fallback if ANDROID_ID is
/// ever unavailable.
Future<String> _persistedUuid() async {
  String? id = await _secureStorage.read(key: _deviceUuidKey);
  if (id == null) {
    id = const Uuid().v4();
    await _secureStorage.write(key: _deviceUuidKey, value: id);
  }
  return id;
}

/// The device's local network IP (its address on the current Wi-Fi/mobile
/// network), e.g. "192.168.1.23" -- not a public/internet-facing IP. Returns
/// "unknown" if no active network interface can be found.
Future<String> getDeviceIpAddress() async {
  try {
    for (var interface in await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.IPv4,
    )) {
      for (var addr in interface.addresses) {
        if (!addr.isLoopback) {
          return addr.address;
        }
      }
    }
  } catch (_) {
    // Fall through to "unknown" below.
  }
  return "unknown";
}
