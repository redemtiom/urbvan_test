import 'package:flutter/material.dart';
import 'package:urbvan_test/viewmodels/google_map_vm.dart';
import 'package:provider/provider.dart';

class MarkerControlls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: ElevatedButton(
            onPressed: () => {context.read<GoogleMapModel>().removeMarker()},
            child: Icon(Icons.wrong_location_outlined),
          ),
        ),
        SizedBox(),
        Container(
          child: ElevatedButton(
            onPressed: () => {context.read<GoogleMapModel>().removeMarkers()},
            child: Icon(Icons.location_off_outlined),
          ),
        ),
      ],
    );
  }
}
