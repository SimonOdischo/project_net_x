import 'dart:io';
import 'dart:async';
import 'package:carrier_info/carrier_info.dart';
import 'package:network_type_reachability/network_type_reachability.dart';

//Folgende Methode erkennt mit welchen Netwerktyp das gerät verbunden ist (4G, WLAN etc.)
Future<String> getCurrentNetworkStatus() async {
  if (Platform.isAndroid) {
    await NetworkTypeReachability().getPermisionsAndroid;
  }
  NetworkStatus status = await NetworkTypeReachability().currentNetworkStatus();
  switch (status) {
    case NetworkStatus.otherMoblie:
    //other
    case NetworkStatus.unreachable:
    //unreachable
    case NetworkStatus.wifi:
    //wifi
    case NetworkStatus.mobile2G:
    //2g
    case NetworkStatus.moblie3G:
    //3g
    case NetworkStatus.moblie4G:
    //4g
    case NetworkStatus.moblie5G:
    //5h
  }
  if (status == NetworkStatus.wifi) {
    return status.toString();
  } else {
    String? carrierInfo = await CarrierInfo.networkGeneration;
    //  String? carriername = await CarrierInfo.carrierName;
//carriername.toString() + " " +
    return "Mobilfunkstandards: " + carrierInfo.toString();
  }
}
