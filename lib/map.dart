import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class MapG extends StatefulWidget {
  final double lat;
  final double lng;

  @override
  _MapGState createState() => _MapGState();

  MapG({Key key, this.lat, this.lng}) : super(key: key);
}

class _MapGState extends State<MapG> {
  String _mapStyle;
  LatLng _kMapCenter = LatLng(52.4478, -3.5402);
  //LatLng _lastLongPress;
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 0;
  PolylineId selectedPolyline;
  int conta = 0;
  GoogleMapController controller;
  BitmapDescriptor _markerIcon;
  Set<Marker> _markers = {};

  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    /*BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'assets/icons/satellit128.png')
        .then((value) => _markerIcon = value);*/

    super.initState();
  }

  updateCounter() {
    Timer.periodic(Duration(seconds: 10), (timer) {
      getIssPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    getGDirection();
    return GoogleMap(
      myLocationEnabled: true,
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      initialCameraPosition: CameraPosition(target: _kMapCenter, zoom: 14.4746),
      markers: _markers,
      onMapCreated: _onMapCreated,
      polylines: Set<Polyline>.of(polylines.values),
      onLongPress: (LatLng pos) => {
        setState(() {
          _markers.add(_createMarker(pos, conta++));
        })
      },
    );
  }

  Future<void> getIssPosition() async {
    final response =
        await http.get(Uri.http('api.open-notify.org', '/iss-now.json'));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      double issLat = double.parse(body['iss_position']['latitude']);
      double issLng = double.parse(body['iss_position']['longitude']);

      setState(() {
        _markers.add(Marker(
          markerId: MarkerId("<MARKER_ID>"),
          position: LatLng(issLat, issLng),
          icon: _markerIcon,
        ));
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            //bearing: 192.8334901395799,
            target: LatLng(issLat, issLng),
            //tilt: 59.440717697143555,
            zoom: 2.0)));
      });
    } else {
      print('error oh no no no $response');
    }
  }

  Marker _createMarker(LatLng pos, int mID) {
    if (_markerIcon != null) {
      return Marker(
        markerId: MarkerId("marker_$mID"),
        position: pos,
        icon: _markerIcon,
      );
    } else {
      return Marker(
        markerId: MarkerId("marker_$mID"),
        position: pos,
      );
    }
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
      controller.setMapStyle(_mapStyle);
    });
    //updateCounter();
  }

  Future<void> getGDirection() async {
    final response = await http.get(
        Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
      'origin': '17.303309, -96.915310',
      'destination': '17.300645, -96.911158',
      'key': 'ENTER_YOUR_API_KEY_HERE'
    }));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      print('my body: $body');
    }
  }
}
