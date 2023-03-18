import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/main.dart';
import 'package:testing/models/network_info_model.dart';

/*
Die Datei ist für das Bilden
der Messverlauf Page in der App
*/
class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<NetworkInfo> netWorkInfos = [];
  late List<NetworkInfo> searchNetWorkInfos = [];
  bool loading = false;
  String query = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //überprüft ob data local gespeichert sind.
      future: loadData(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Daten werden geladen...'));
        }
        if (netWorkInfos.isEmpty) {
          return const Center(child: Text('Keine Messdaten...'));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(12),
            separatorBuilder: ((context, index) {
              return SizedBox(
                height: 12,
              );
            }),
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                onTap: () async {
                  saveIndex(index);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          MyHomePage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                title: Text("Messzeit: " +
                    netWorkInfos[index].datumZeit +
                    "\n" +
                    netWorkInfos[index].status +
                    "\n" +
                    netWorkInfos[index].ping +
                    " Ping" +
                    "\n" +
                    netWorkInfos[index].dBm +
                    " stärke in dBm" +
                    "\n" +
                    netWorkInfos[index].strasse +
                    "\n" +
                    netWorkInfos[index].pzl +
                    "\n" +
                    netWorkInfos[index].land),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Icon(
                    Icons.delete_forever_outlined,
                    color: Color.fromARGB(206, 248, 23, 7),
                  ),
                  onPressed: () {
                    print(netWorkInfos.length);
                    print("länge");
                    deleteData(index);
                  },
                ),
              ));
            },
            itemCount: netWorkInfos.length,
          );

          //  SingleChildScrollView(
          //   child: Container(
          //       padding: const EdgeInsets.all(30),
          //       child: Expanded(
          //         child: ListView.builder(
          //             shrinkWrap: true,
          //             itemCount: netWorkInfos.length,
          //             itemBuilder: (context, index) => Card(
          //                   child: ListTile(
          //                     onTap: () async {
          //                       saveIndex(index);
          //                       Navigator.pushReplacement(
          //                         context,
          //                         PageRouteBuilder(
          //                           pageBuilder:
          //                               (context, animation1, animation2) =>
          //                                   MyHomePage(),
          //                           transitionDuration: Duration.zero,
          //                           reverseTransitionDuration: Duration.zero,
          //                         ),
          //                       );
          //                     },
          //                     title: Text("Messzeit: " +
          //                         netWorkInfos[index].datumZeit +
          //                         "\n" +
          //                         netWorkInfos[index].status +
          //                         "\n" +
          //                         netWorkInfos[index].ping +
          //                         " Ping" +
          //                         "\n" +
          //                         netWorkInfos[index].dBm +
          //                         " stärke in dBm" +
          //                         "\n" +
          //                         netWorkInfos[index].strasse +
          //                         "\n" +
          //                         netWorkInfos[index].pzl +
          //                         "\n" +
          //                         netWorkInfos[index].land),
          //                     trailing: ElevatedButton(
          //                       style: ElevatedButton.styleFrom(
          //                           backgroundColor: Colors.blue),
          //                       child: const Icon(
          //                         Icons.delete_forever_outlined,
          //                         color: Color.fromARGB(206, 248, 23, 7),
          //                       ),
          //                       onPressed: () {
          //                         print(netWorkInfos.length);
          //                         print("länge");
          //                         deleteData(index);
          //                       },
          //                     ),
          //                   ),
          //                 )),
          //       )),
          // );
        }
      },
    );
  }

//Diese Methode nimmt die index und löscht die data nach index
  deleteData(int index) {
    netWorkInfos.removeAt(index);
    List<NetworkInfo> items = netWorkInfos;
    saveData(items);
  }

//Diese Methode nimmt die index und speichert die data nach index
  saveIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("index", index);
  }

  saveData(List<NetworkInfo> liste) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var json = jsonEncode(liste);

    await prefs.setString('favorites', json);

    setState(() {
      loadData();
    });
  }

//Die mehthode dient zum laden die Daten aus der Lokale speicherung
  Future<String> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // reading
    var resJson = prefs.getString('favorites') ?? '';

    var parsedJson = jsonDecode(resJson);

    List<NetworkInfo> items =
        List<NetworkInfo>.from(parsedJson.map((i) => NetworkInfo.fromJson(i)));

    netWorkInfos = items;
    print(items.length);
    print("Von Load Method");
    return "";
  }

  // Widget buildSearch() => SearchWidget(
  //       text: query,
  //       hintText: "In History suchen",
  //       onChanged: search,
  //     );

  // void search(String query) {
  //   final stand = netWorkInfos.where((data) {
  //     final datumZeit = data.datumZeit.toLowerCase();
  //     final status = data.status.toLowerCase();
  //     final ping = data.ping.toLowerCase();
  //     final dBm = data.dBm.toLowerCase();
  //     final positionLatitude = data.positionLatitude.toLowerCase();
  //     final positionLongitude = data.positionLongitude.toLowerCase();
  //     final strasse = data.strasse.toLowerCase();
  //     final pzl = data.pzl.toLowerCase();
  //     final land = data.land.toLowerCase();

  //     final searchLower = query.toLowerCase();

  //     return datumZeit.contains(searchLower) ||
  //         status.contains(searchLower) ||
  //         ping.contains(searchLower) ||
  //         dBm.contains(searchLower) ||
  //         positionLatitude.contains(searchLower) ||
  //         positionLongitude.contains(searchLower) ||
  //         strasse.contains(searchLower) ||
  //         pzl.contains(searchLower) ||
  //         land.contains(searchLower);
  //   }).toList();

  //   setState(() {
  //     this.query = query;
  //     searchNetWorkInfos = stand;
  //   });
  // }
}
