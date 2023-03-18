class NetworkInfo {
  //modal class for Networkdata object
  String datumZeit,
      status,
      ping,
      dBm,
      positionLatitude,
      positionLongitude,
      strasse,
      pzl,
      land;
  NetworkInfo(
      {required this.datumZeit,
      required this.status,
      required this.ping,
      required this.dBm,
      required this.positionLatitude,
      required this.positionLongitude,
      required this.strasse,
      required this.pzl,
      required this.land});

  factory NetworkInfo.fromJson(Map<String, dynamic> infoJson) {
    return NetworkInfo(
      datumZeit: infoJson['datumZeit'] ?? "",
      status: infoJson['status'] ?? "",
      ping: infoJson['ping'] ?? "",
      dBm: infoJson['dBm'] ?? "",
      positionLatitude: infoJson['positionLatitude'] ?? "",
      positionLongitude: infoJson['positionLongitude'] ?? "",
      strasse: infoJson['strasse'] ?? "",
      pzl: infoJson['pzl'] ?? "",
      land: infoJson['land'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "datumZeit": datumZeit,
      "status": status,
      "ping": ping,
      "dBm": dBm,
      "positionLatitude": positionLatitude,
      "positionLongitude": positionLongitude,
      "strasse": strasse,
      "pzl": pzl,
      "land": land,
    };
  }
}
