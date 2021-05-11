import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Map extends StatefulWidget {
  final double lat;
  final double lng;

  @override
  _MapState createState() => _MapState();

  Map({Key key, this.lat, this.lng}) : super(key: key);
}

class _MapState extends State<Map> {
  String _mapStyle;
  LatLng _kMapCenter = LatLng(52.4478, -3.5402);
  GoogleMapController controller;
  BitmapDescriptor _markerIcon;
  //Marker issMarker;
  Set<Marker> _markers = {};

  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'assets/icons/satellit128.png')
        .then((value) => _markerIcon = value);

    super.initState();
  }

  updateCounter() {
    Timer.periodic(Duration(seconds: 10), (timer) {
      getIssPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      initialCameraPosition: CameraPosition(target: _kMapCenter, zoom: 14.4746),
      markers: _markers,
      onMapCreated: _onMapCreated,
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

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
      controller.setMapStyle(_mapStyle);
    });
    //getIssPosition();
    updateCounter();
  }
}
