import 'package:google_maps_flutter/google_maps_flutter.dart';

// This function was taken from: https://gist.github.com/BoHellgren/aa2438f837bc675061cbb156ba83ea35 to decode Polylines
// Google documentation https://developers.google.com/maps/documentation/utilities/polylinealgorithm

List<LatLng> decodeEncodedPolyline(String encoded) {
  List<LatLng> poly = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;
  BigInt Big0 = BigInt.from(0);
  BigInt Big0x1f = BigInt.from(0x1f);
  BigInt Big0x20 = BigInt.from(0x20);

  while (index < len) {
    int shift = 0;
    BigInt b, result;
    result = Big0;
    do {
      b = BigInt.from(encoded.codeUnitAt(index++) - 63);
      result |= (b & Big0x1f) << shift;
      shift += 5;
    } while (b >= Big0x20);
    BigInt rshifted = result >> 1;
    int dlat;
    if (result.isOdd)
      dlat = (~rshifted).toInt();
    else
      dlat = rshifted.toInt();
    lat += dlat;

    shift = 0;
    result = Big0;
    do {
      b = BigInt.from(encoded.codeUnitAt(index++) - 63);
      result |= (b & Big0x1f) << shift;
      shift += 5;
    } while (b >= Big0x20);
    rshifted = result >> 1;
    int dlng;
    if (result.isOdd)
      dlng = (~rshifted).toInt();
    else
      dlng = rshifted.toInt();
    lng += dlng;

    poly.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
  }
  return poly;
}
