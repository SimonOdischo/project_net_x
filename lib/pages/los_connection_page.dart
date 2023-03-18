import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class loseConnect extends StatefulWidget {
  const loseConnect({Key? key}) : super(key: key);

  @override
  loseConnectState createState() => loseConnectState();
}

class loseConnectState extends State<loseConnect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox.fromSize(
            size: Size.fromRadius(100),
            child: FittedBox(
              child: Icon(
                Icons.perm_scan_wifi_rounded,
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Internet connection lost!',
            style: TextStyle(fontSize: 20, color: Colors.blue),
          ),
          const Text(
            'Check your connection and try again.',
            style: TextStyle(fontSize: 20, color: Colors.blue),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                AppSettings.openWIFISettings();
              },
              child: Text('go to Wifi Setting')),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                AppSettings.openDataRoamingSettings();
              },
              child: Text('go to Net Setting'))
        ],
      )),
    );
  }
}

/// Bildet die PupUp fenster beim verlust die Internetverbindung erschient
popup(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox.fromSize(
                size: Size.fromRadius(100),
                child: FittedBox(
                  child: Icon(
                    Icons.perm_scan_wifi_rounded,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Keine Internetverbindung!',
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              const Text(
                'überprüfe deine Verbindung',
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    AppSettings.openWIFISettings();
                  },
                  child: Text('WLAN-Einstellungen')),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    AppSettings.openDataRoamingSettings();
                  },
                  child: Text('Mobilfunk-Einstellungen'))
            ],
          )),
        );
      });
}
