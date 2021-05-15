import 'package:flutter/material.dart';
import 'package:urbvan_test/viewmodels/google_map_vm.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class MapUiControlls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String option = Provider.of<GoogleMapModel>(context).option;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: option == 'iss'
                ? () => {
                      HapticFeedback.mediumImpact(),
                      Provider.of<GoogleMapModel>(context, listen: false)
                          .getDirecction()
                    }
                : null,
            child: Icon(Icons.alt_route)),
        SizedBox(
          width: 10.0,
        ),
        ElevatedButton(
            onPressed: option == 'direction'
                ? () => {
                      HapticFeedback.mediumImpact(),
                      Provider.of<GoogleMapModel>(context, listen: false)
                          .getIss()
                    }
                : null,
            child: Icon(Icons.satellite))
      ],
    );
  }
}
