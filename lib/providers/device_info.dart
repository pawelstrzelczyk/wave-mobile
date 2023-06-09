import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';

class DeviceInfoController extends ChangeNotifier {
  BaseDeviceInfo? baseDeviceInfo;
  AndroidDeviceInfo? androidDeviceInfo;
  IosDeviceInfo? iosDeviceInfo;

  String? sdkInt;
  String? release;
  String? model;
  String? brand;
  String? product;
  String? manufacturer;

  getDeviceInfo() async {
    if (Platform.isAndroid) {
      baseDeviceInfo = await DeviceInfoPlugin().deviceInfo;
      sdkInt = baseDeviceInfo?.data['version']['sdkInt'].toString();
      release = baseDeviceInfo?.data['version']['release'].toString();
      model = baseDeviceInfo?.data['model'].toString();
      brand = baseDeviceInfo?.data['brand'].toString();
      product = baseDeviceInfo?.data['product'].toString();
      manufacturer = baseDeviceInfo?.data['manufacturer'].toString();
    } else if (Platform.isIOS) {
      iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
      sdkInt = iosDeviceInfo?.data['systemName'].toString();
      release =
          "${iosDeviceInfo?.data['systemVersion'].toString()} ${iosDeviceInfo?.data['utsname']['sysname'].toString()} ${iosDeviceInfo?.data['utsname']['release'].toString()}";
      model = iosDeviceInfo?.data['model'].toString();
      brand = iosDeviceInfo?.data['localizedModel'].toString();
      product = iosDeviceInfo?.data['name'].toString();
      manufacturer = 'Apple';
    }
    notifyListeners();
  }
}
