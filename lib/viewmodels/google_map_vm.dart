import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbvan_test/utils/google_map_utils.dart';
import 'package:flutter/material.dart';
import 'package:urbvan_test/sevices/locations.dart';
import 'package:flutter/services.dart';

class GoogleMapModel extends ChangeNotifier {
  Set<Marker> _markers = {};
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  final _mapCenter = LatLng(19.433918, -99.1381993);
  int _polylineIdCounter = 0;
  int _markerIdCounter = 0;
  GoogleMapController _controller;
  Timer _timer;
  String _option = "direction";
  BitmapDescriptor _markerIcon;

  LatLng get initialCameraPosition => _mapCenter;

  GoogleMapController get controller => _controller;

  set controller(GoogleMapController controllerReady) {
    _controller = controllerReady;
    rootBundle.loadString('assets/map_style.txt').then((value) => _controller.setMapStyle(value));
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'assets/icons/satellit128.png')
        .then((value) => _markerIcon = value);

    notifyListeners();
  }

  String get option => _option;

  set option(String optionParam){
    _option = optionParam;

    notifyListeners();
  }

  Set<Marker> get markers => _markers;

  get polylines => _polylines;

  void addPolyline() async {
    if (_markers.length > 1) {
      final parseOrigin = jsonDecode(jsonEncode(_markers.first));
      final parseDestination = jsonDecode(jsonEncode(_markers.last));
      var origin =
          "${parseOrigin['position'][0]},${parseOrigin['position'][1]}";
      var destination =
          "${parseDestination['position'][0]},${parseDestination['position'][1]}";
      final encodePoly =
          await Service().fetchGoogleDirection(origin, destination);

      final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
      _polylineIdCounter++;
      final PolylineId polylineId = PolylineId(polylineIdVal);

      final Polyline polyline = Polyline(
        polylineId: polylineId,
        consumeTapEvents: true,
        color: Colors.orange,
        width: 5,
        points: decodeEncodedPolyline(encodePoly),
      );
      _polylines[polylineId] = polyline;

      notifyListeners();
    }
  }

  Future<void> fetchIssPosition() async {
    final response = await Service().fetchIssPosition();

    double issLat = double.parse(response['iss_position']['latitude']);
    double issLng = double.parse(response['iss_position']['longitude']);

    _markers.add(Marker(
      markerId: MarkerId("<MARKER_ID>"),
      position: LatLng(issLat, issLng),
      icon: _markerIcon,
    ));
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(issLat, issLng), zoom: 2.0),
      ),
    );

    notifyListeners();
  }

  void getIss() {
    _markers = {};
    _polylines = <PolylineId, Polyline>{};
    _option = 'iss';

    fetchIssPosition();

    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchIssPosition();
    });
  }

  void getDirecction(){
    _markers = {};
    _option = 'direction';
    _timer.cancel();
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _mapCenter, zoom: 14.4746),
      ),
    );

    notifyListeners();
  }

  void addMarker(LatLng position) {
    _markerIdCounter++;
    _markers.add(Marker(
      markerId: MarkerId("marker_$_markerIdCounter"),
      position: position,
    ));

    addPolyline();

    notifyListeners();
  }

  void removeMarker() {
    _markers.remove(_markers.last);
    _markerIdCounter--;

    if(_markers.length > 1){
      _polylines.remove(PolylineId('polyline_id_${--_polylineIdCounter}'));
    } else {
      _polylines = <PolylineId, Polyline>{};
    }

    notifyListeners();
  }

  void removeMarkers() {
    _markers = {};
    _markerIdCounter = 0;
    _polylines = <PolylineId, Polyline>{};
    _polylineIdCounter = 0;

    notifyListeners();
  }
}
