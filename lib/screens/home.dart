import 'package:flutter/material.dart';
import 'package:urbvan_test/viewmodels/google_map_vm.dart';
import 'package:provider/provider.dart';
import 'package:urbvan_test/components/markers_controlls.dart';
import 'package:urbvan_test/components/map_ui_controlls.dart';
import 'package:urbvan_test/components/map.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String option = Provider.of<GoogleMapModel>(context).option;
    return Stack(
      children: [
        MapG(),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              option == 'direction'
                  ? Expanded(
                      child: Container(
                          alignment: AlignmentDirectional.centerStart,
                          margin: EdgeInsets.only(left: 10.0),
                          child: MarkerControlls()),
                    )
                  : Container(),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: MapUiControlls(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
