import 'dart:async';
import 'package:flutter/services.dart';
import 'package:gsm_info/gsm_info.dart';

//Dies ist für die dBm messung
Future<int> getNetworddBm() async {
  int platformVersion = 0;

  try {
    platformVersion = await GsmInfo.gsmSignalDbM;
  } on PlatformException {
    platformVersion = -999;
    return platformVersion;
  }

  return platformVersion;
}
