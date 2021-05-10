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
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }
  /*static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(19.430751, -99.133064),
    zoom: 14.4746,
  );*/

  /*static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);*/

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      initialCameraPosition:
          CameraPosition(target: LatLng(widget.lat, widget.lng), zoom: 14.4746),
      onMapCreated: (GoogleMapController controller) {
        controller.setMapStyle(_mapStyle);
        _controller.complete(controller);
      },
    );
    /*floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),*/
  }

  Future<void> getIssPosition() async {
    final response =
      await http.get(Uri.http('api.open-notify.org', '/iss-now.json'));
    if(response.statusCode == 200){
      print(jsonDecode(response.body));
    }else{
      print('error oh no no no $response');
    }
  }

  /*Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }*/
}
