import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbvan_test/viewmodels/google_map_vm.dart';
import 'package:provider/provider.dart';

class MapG extends StatefulWidget {
  @override
  _MapGState createState() => _MapGState();
}

class _MapGState extends State<MapG> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<GoogleMapModel>(
        builder: (context, googleM, child) => GoogleMap(
          myLocationEnabled: true,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
              target: googleM.initialCameraPosition, zoom: 14.4746),
          markers: googleM.markers,
          onMapCreated: (GoogleMapController controllerParam) =>
              {googleM.controller = controllerParam},
          polylines: Set<Polyline>.of(googleM.polylines.values),
          onLongPress: _onLongPress,
        ),
      ),
    );
  }

  void _onLongPress(LatLng pos) {
    context.read<GoogleMapModel>().addMarker(pos);
  }
}
