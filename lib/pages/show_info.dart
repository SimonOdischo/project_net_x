import 'package:flutter/material.dart';

// Bildet die PupUp fenster die nach erfolgereiche Messung erschient
popupData(BuildContext context, String zeit, String netStatus,
    String pingStatus, int statusdBm, String strasse, String pzl, String land) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Messung erfolgreich",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              //MessDaten
              Text(
                "Messzeit: " +
                    zeit +
                    "\n" +
                    netStatus +
                    "\n" +
                    pingStatus +
                    " Ping " +
                    "\n" +
                    statusdBm.toString() +
                    " in dBm" +
                    "\n" +
                    strasse +
                    "\n" +
                    pzl +
                    "\n" +
                    land,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Ok",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
