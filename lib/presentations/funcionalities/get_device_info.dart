import 'dart:io' as io;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

Future<String> getDeviceInfo() async {
  if (kIsWeb) {
    return 'Web Browser';
  }

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String deviceInfo = '';

  if (io.Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    deviceInfo = 'iOS ${iosInfo.systemVersion} - ${iosInfo.model}';
  } else if (io.Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    deviceInfo =
        'Android ${androidInfo.version.release} - ${androidInfo.model}';
  }

  return deviceInfo;
}
