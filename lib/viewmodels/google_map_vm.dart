import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbvan_test/utils/google_map_utils.dart';
import 'package:flutter/material.dart';
import 'package:urbvan_test/sevices/locations.dart';

class GoogleMapModel extends ChangeNotifier {
  final Set<Marker> _markers = {};
  final Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 0;
  int _markerIdCounter = 0;
  //GoogleMapController controller;
  //BitmapDescriptor _markerIcon;

  Set<Marker> get markers => _markers;

  void addPolyline(String encodePoly) {
    /*final int polylineCount = _polylines.length;

    if (polylineCount == 12) {
      return;
    }*/

    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.orange,
      width: 5,
      points: decodeEncodedPolyline(encodePoly),
      /*onTap: () {
        _onPolylineTapped(polylineId);
      },*/
    );
    _polylines[polylineId] = polyline;

    notifyListeners();
  }

  Future<void> fetchIssPosition() async {
    final results = await Service().fetchIssPosition();
    //print('my results: $results');
    notifyListeners();
  }

  void addMarker(LatLng position) {
    _markerIdCounter++;
    _markers.add(Marker(
      markerId: MarkerId("marker_$_markerIdCounter"),
      position: position,
    ));

    notifyListeners();
  }

  void removeMarker() {
    _markers.remove(_markers.length - 1);

    notifyListeners();
  }

  void removeMarkers() {
    _markers.removeAll(_markers);

    notifyListeners();
  }
}
