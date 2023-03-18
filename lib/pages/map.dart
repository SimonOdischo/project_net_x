import 'dart:convert';
import 'package:carrier_info/carrier_info.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/controller/location_controller.dart';
import 'package:testing/pages/los_connection_page.dart';
import 'package:testing/pages/show_info.dart';
import 'package:testing/services/netwok_status.dart';
import 'package:testing/services/network_dBm.dart';
import 'package:testing/models/network_info_model.dart';
import 'package:testing/services/found_address.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

/*
Die Datei ist für das Bilden
der Map auf der HomePage in der App
*/

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  State<MyMap> createState() => _MyAppState();
}

class _MyAppState extends State<MyMap> {
  double currentZoom = 13.0;
  final double currentZoomIn = 13.0;
  MapController mapController = MapController();
  late LatLng currentCenter;
  late String positionLatitude;
  late String positionLongitude;
  LatLng currentCenterHH = LatLng(52.3731484504969, 9.727223420649203);
  late bool _isServiceEnabled;
  late PermissionStatus _permissionGranted;
  bool? isGetLocation;
  Location location = Location();
  late LatLng mapPosition;
  List<LatLng> position = <LatLng>[];
  late LatLng markerPosition;
  bool loading = false;
  PopupController popupLayerController = PopupController();
  List<NetworkInfo> netWorkInfos = [];
  List<Marker> markers = [];
  bool connect = true;
  late String netStatus;
  late String pingStatus;
  late String statusdBm;
  late String messZeit;

  late CarrierData carrierInfo;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getCurrentLocation();
    getRealPosition();
    loadFavorites();
    showMarker();
  }

  Future<void> initPlatformState() async {
    await [
      perm.Permission.locationWhenInUse,
      perm.Permission.phone,
    ].request();

    try {
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

//Methode zum zeigen der Marker auf die Map
  showMarker() async {
    int index = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("index") == null) {
      return;
    } else {
      var resJson = prefs.getString('favorites') ?? '';
      index = prefs.getInt("index")!;
      if (resJson.isNotEmpty && index != 0) {}
      var parsedJson = jsonDecode(resJson);

      List<NetworkInfo> items = List<NetworkInfo>.from(
          parsedJson.map((i) => NetworkInfo.fromJson(i)));

      double? lati = double.tryParse(items[index].positionLatitude);
      double? long = double.tryParse(items[index].positionLongitude);
      LatLng posit = LatLng(lati!, long!);

      markerPosition = posit;
      mapController.move(posit, currentZoom);
      netStatus = items[index].status;
      pingStatus = items[index].ping;
      statusdBm = items[index].dBm;
      messZeit = items[index].datumZeit;
      _handleTap();
      prefs.remove("index");
    }
  }

  ///Methode zum Zoom Out
  _zoomOut() {
    currentZoom = currentZoom - 1;
    mapController.move(mapPosition, currentZoom);
  }

  ///Methode zum Zoom In
  _zoomIn() {
    currentZoom = currentZoom + 1;
    mapController.move(mapPosition, currentZoom);
  }

  ///Methode an die Aktuelle Position zu führen
  void concurrentPosition() {
    if (isGetLocation == true) {
      mapController.move(currentCenter, currentZoomIn);
    } else {
      mapController.move(currentCenterHH, currentZoomIn);
    }
  }

  ///position festlegen
  void setPosition(LatLng center) {
    mapPosition = center;
  }

//Folgende Methode holt die aktuelle Position
  getCurrentLocation() {
    geo.Geolocator.getCurrentPosition(
            desiredAccuracy: geo.LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((geo.Position position) {
      setState(() {
        currentCenter = LatLng(position.latitude, position.longitude);
        mapController.move(currentCenter, currentZoomIn);
      });
    }).catchError((e) {
      print(e);
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: location.onLocationChanged,
      builder: (context, snapshot) {
        if (snapshot.data != null &&
            snapshot.connectionState != ConnectionState.waiting) {
          var data = snapshot.data as LocationData;
          LatLng posit = LatLng(data.latitude!, data.longitude!);
          currentCenter = posit;
          positionLatitude = data.latitude!.toString();
          positionLongitude = data.longitude!.toString();

          isGetLocation = true;
          return mapBuild(currentCenter);
        } else {
          isGetLocation = false;
          return mapBuild(currentCenterHH);
        }
      },
    );
  }

  Widget mapBuild(LatLng centerposition) {
    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          onPositionChanged: (position, e) {
            setPosition(mapController.center);
          },
          minZoom: 10.0,
          center: centerposition,
          interactiveFlags: InteractiveFlag.all,
          onTap: (_, __) => popupLayerController.hideAllPopups(),
        ),
        children: [
          TileLayerWidget(
              options: TileLayerOptions(
            maxNativeZoom: 18,
            maxZoom: 22,
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          )),
          PopupMarkerLayerWidget(
              options: PopupMarkerLayerOptions(
                  popupController: popupLayerController,
                  markers: markers,
                  markerRotateAlignment:
                      PopupMarkerLayerOptions.rotationAlignmentFor(
                          AnchorAlign.top),
                  popupBuilder: (_, Marker marker) {
                    return markerPupUp();
                  })),
          MarkerLayerWidget(
              options: MarkerLayerOptions(markers: <Marker>[
            Marker(
                height: 60,
                width: 60,
                builder: (_) {
                  if (centerposition == currentCenterHH) {
                    return withoutMarker();
                  } else {
                    return const AnimationMarker();
                  }
                },
                point: centerposition),
          ])),
          PolylineLayerWidget(
              options: PolylineLayerOptions(polylines: [
            Polyline(points: position, strokeWidth: 5.0, color: Colors.blue)
          ], polylineCulling: true)),
        ],
      ),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        buildScanButton(),
        const SizedBox(height: 250),
        buildButton(
            "btn2",
            _zoomIn,
            "zoomIn",
            Icons.zoom_in_sharp,
            const Color.fromARGB(255, 225, 225, 225),
            const Color.fromARGB(255, 90, 89, 89)),
        const SizedBox(height: 1),
        buildButton(
            "btn3",
            _zoomOut,
            "zoomOut",
            Icons.zoom_out_sharp,
            const Color.fromARGB(255, 225, 225, 225),
            const Color.fromARGB(255, 90, 89, 89)),
        const SizedBox(height: 1),
        buildButton(
            "btn4",
            concurrentPosition,
            "Position",
            Icons.my_location_rounded,
            const Color.fromARGB(255, 225, 225, 225),
            const Color.fromARGB(255, 90, 89, 89)),
        const SizedBox(height: 10),
      ]),
    );
  }

  _handleTap() {
    setState(() {
      markers.add(
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.top),
          point: markerPosition,
          width: 40,
          height: 30,
          builder: (BuildContext ctx) => const Icon(
            Icons.location_on,
            size: 35.0,
            color: Colors.blue,
          ),
        ),
      );
    });
  }

//folgende Methode dient für die NetzMessung
  void scan() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      List<String> adress;
      loading = true;
      int? pingStatus = 0;
      String netStatus = 'Unknown';
      int statusdBm = 0;
      final ping = Ping('google.com', count: 1);
      ping.stream.listen((event) {
        DateTime dateToday = DateTime.now();
        String zeit = DateFormat('dd-MM-yyyy').format(DateTime.now()) +
            " " +
            dateToday.hour.toString() +
            ":" +
            dateToday.minute.toString() +
            ":" +
            dateToday.second.toString(); // 2021-06-24
        Future.delayed(const Duration(seconds: 4), () async {
          pingStatus = event.response?.time?.inMilliseconds.toInt();
          statusdBm = await getNetworddBm();
          netStatus = await getCurrentNetworkStatus();
          adress = await GetAddressFromLatLong(
              positionLatitude.toString(), positionLongitude.toString());
          setState(() {
            netWorkInfos.add(NetworkInfo(
                datumZeit: zeit,
                status: netStatus,
                ping: pingStatus.toString(),
                dBm: statusdBm.toString(),
                positionLatitude: positionLatitude.toString(),
                positionLongitude: positionLongitude.toString(),
                strasse: adress[0],
                pzl: adress[1],
                land: adress[2]));
          });
          saveData();
          loading = false;
          popupData(context, zeit, netStatus, pingStatus.toString(), statusdBm,
              adress[0], adress[1], adress[2]);
        });
      });
    } else {
      popup(context);
    }
  }

  ///Die Buttons auf der Map genereieren
  Widget buildButton(String tag, Function() function, String tip,
      IconData iconData, Color color1, Color color2) {
    return FloatingActionButton(
      splashColor: Colors.transparent,
      enableFeedback: false,
      shape: const RoundedRectangleBorder(),
      backgroundColor: color1,
      heroTag: tag, //Exception Vermeiden
      onPressed: function,
      tooltip: tip,
      foregroundColor: color2,
      child: Icon(iconData),
    );
  }

  ///Die Buttons auf der Map genereieren
  Widget buildScanButton() {
    return FloatingActionButton(
        shape: const RoundedRectangleBorder(),
        backgroundColor: Colors.blue,
        heroTag: "btn1", //Exception Vermeiden
        onPressed: scan,
        tooltip: "Network Scan",
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        child: loading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              )
            : const Icon(Icons.network_check));
  }

  ///dies bildet die popup für die marker
  ///auf der Map
  Widget markerPupUp() {
    return SizedBox(
      width: 200,
      child: Card(
        color: Theme.of(context).colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 10),
            Text("Messzeit: " + messZeit),
            Text(netStatus),
            Text("$pingStatus Ping"),
            Text("$statusdBm dBm"),
          ],
        ),
      ),
    );
  }

  ///Gerät Position abfrage ermittlen
  getRealPosition() async {
    _isServiceEnabled = await location.serviceEnabled();
    if (!_isServiceEnabled) {
      _isServiceEnabled = await location.requestService();
      if (_isServiceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }
  }

//Dient zum speichern die Daten
  saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = jsonEncode(netWorkInfos);

    await prefs.setString('favorites', json);
  }

//Dient zum laden die gespeicherten Daten
  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var resJson = prefs.getString('favorites') ?? '';

    var parsedJson = jsonDecode(resJson);

    List<NetworkInfo> items =
        List<NetworkInfo>.from(parsedJson.map((i) => NetworkInfo.fromJson(i)));

    netWorkInfos = items;
  }
}
