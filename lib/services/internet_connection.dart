import 'dart:io';

//Folgende Methode test ob Internetverbindung besteht
Future<bool> hasNetwork() async {
  try {
    await InternetAddress.lookup('google.com');
    //return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    return true;
  } on SocketException catch (_) {
    return false;
  }
}
