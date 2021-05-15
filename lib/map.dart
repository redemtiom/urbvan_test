import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter/services.dart';
import 'package:urbvan_test/viewmodels/google_map_vm.dart';
import 'package:provider/provider.dart';

class MapG extends StatefulWidget {
  @override
  _MapGState createState() => _MapGState();
}

class _MapGState extends State<MapG> {
  //String _mapStyle;
  PolylineId selectedPolyline;
  //BitmapDescriptor _markerIcon;

  /*@override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'assets/icons/satellit128.png')
        .then((value) => _markerIcon = value);

    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<GoogleMapModel>(
        builder: (context, googleM, child) => GoogleMap(
          myLocationEnabled: true,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          initialCameraPosition:
              CameraPosition(target: googleM.initialCameraPosition, zoom: 14.4746),
          markers: googleM.markers,
          onMapCreated: (GoogleMapController controllerParam) => {googleM.controller = controllerParam},
          polylines: Set<Polyline>.of(googleM.polylines.values),
          onLongPress: _onLongPress,
        ),
      ),
    );
  }

  void _onLongPress(LatLng pos) {
    context.read<GoogleMapModel>().addMarker(pos);
  }

  /*Marker _createMarker(LatLng pos, int mID) {
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
  }*/

  /*void _onMapCreated(GoogleMapController controllerParam) {
      setState(() {
      controller = controllerParam;
      controller.setMapStyle(_mapStyle);
    });
    updateCounter();
  }*/
}
