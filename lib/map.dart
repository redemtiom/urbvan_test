import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:urbvan_test/viewmodels/google_map_vm.dart';
import 'package:provider/provider.dart';

class MapG extends StatefulWidget {
  final double lat;
  final double lng;

  @override
  _MapGState createState() => _MapGState();

  MapG({Key key, this.lat, this.lng}) : super(key: key);
}

class _MapGState extends State<MapG> {
  String _mapStyle;
  LatLng _kMapCenter = LatLng(19.433918, -99.1381993);
  //LatLng _lastLongPress;
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 0;
  PolylineId selectedPolyline;
  int conta = 0;
  GoogleMapController controller;
  BitmapDescriptor _markerIcon;
  Set<Marker> _markers = {};
  //Set<Polyline> _customP = {};

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
    return Consumer<GoogleMapModel>(
      builder: (context, googleM, child) => GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        initialCameraPosition:
            CameraPosition(target: _kMapCenter, zoom: 14.4746),
        markers: googleM.markers,
        onMapCreated: _onMapCreated,
        polylines: Set<Polyline>.of(polylines.values),
        onLongPress: _onLongPress,
      ),
    );
  }

  void _onLongPress(LatLng pos) {
    setState(() {
      _markers.add(_createMarker(pos, conta++));
    });
    getGDirection();
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
    //if (_markerIcon != null) {

    return Marker(
      markerId: MarkerId("marker_$mID"),
      position: pos,
      //icon: _markerIcon,
    );
    /*} else {
      return Marker(
        markerId: MarkerId("marker_$mID"),
        position: pos,
      );
    }*/
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
      controller.setMapStyle(_mapStyle);
    });
    //updateCounter();
  }

  Future<void> getGDirection() async {
    if (_markers.length > 1) {
      var parseOrigin = jsonDecode(jsonEncode(_markers.elementAt(0)));
      var parseDestiny =
          jsonDecode(jsonEncode(_markers.elementAt(_markers.length - 1)));
      var origin =
          "${parseOrigin['position'][0]},${parseOrigin['position'][1]}";
      var desitny =
          "${parseDestiny['position'][0]},${parseDestiny['position'][1]}";

      final response = await http
          .get(Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
        'origin': origin,
        'destination': desitny,
        'key': 'ENTER_YOUR_API_KEY_HERE'
      }));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        var ppp = body['routes'][0]['overview_polyline']['points'];
        _add(ppp);
        print('my body: $ppp');
      } else {
        print('myresponse: $response');
      }
    }
  }

  void _add(String encodePoly) {
    final int polylineCount = polylines.length;

    if (polylineCount == 12) {
      return;
    }

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

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

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
}
