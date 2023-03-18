import 'package:geocoding/geocoding.dart';

//Die Methode nimmt die Loactaionkoordinaten und gibt die Adresse raus
GetAddressFromLatLong(String lati, String long) async {
  double positionLati = double.parse(lati);
  double positionLong = double.parse(long);

  List<String> adresse = [];
  List<Placemark> placemarks =
      await placemarkFromCoordinates(positionLati, positionLong);
  Placemark place = placemarks[0];

  adresse.add(place.street.toString());
  adresse.add(place.postalCode! + " " + place.locality!);
  adresse.add(place.country.toString());

  return adresse;
}
