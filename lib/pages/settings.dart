import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:testing/pages/impressum_page.dart';

/*
Die Datei ist für das Bilden
der Setting Page in der App
*/
class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Card(
                  clipBehavior: Clip.antiAlias,
                  child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: Colors.black,
                      child: ListTile(
                          leading: const Icon(
                            Icons.wifi,
                            color: Colors.black,
                          ),
                          title: Text(
                            "WLAN",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onTap: () async {
                            AppSettings.openWIFISettings();
                          }))),
              Card(
                  clipBehavior: Clip.antiAlias,
                  child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: Colors.black,
                      child: ListTile(
                          leading: const Icon(
                            Icons.network_cell,
                            color: Colors.black,
                          ),
                          title: Text(
                            "Mobilfunknetz",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onTap: () {
                            AppSettings.openDataRoamingSettings();
                          }))),
              Card(
                  clipBehavior: Clip.antiAlias,
                  child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: Colors.black,
                      child: ListTile(
                          leading: const Icon(
                            Icons.info_outline,
                            color: Colors.black,
                          ),
                          title: Text(
                            "Informationen über die App",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onTap: () {
                            showAboutDialog(
                              context: context,
                              applicationIcon: const FlutterLogo(),
                              applicationLegalese: 'Legalese',
                              applicationName: 'Net-X',
                              applicationVersion: 'version 1.0.0',
                            );
                          }))),
              Card(
                  clipBehavior: Clip.antiAlias,
                  child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: Colors.black,
                      child: ListTile(
                          leading: const Icon(
                            Icons.account_balance_outlined,
                            color: Colors.black,
                          ),
                          title: Text(
                            "Impressum",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Impressumview()),
                            );
                          }))),
            ],
          )),
    ));
  }
}
