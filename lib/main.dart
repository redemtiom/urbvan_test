import 'package:flutter/material.dart';
import 'package:urbvan_test/map.dart';
import 'package:urbvan_test/viewmodels/google_map_vm.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleMapModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String option = Provider.of<GoogleMapModel>(context).option;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            MapG(),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  option == 'direction' ? Expanded(child:Container(
                    alignment: AlignmentDirectional.centerStart,
                    margin: EdgeInsets.only(left: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Container(child: ElevatedButton(onPressed: () => {context.read<GoogleMapModel>().removeMarker()}, child: Icon(Icons.wrong_location_outlined),),),
                      SizedBox(),
                      Container(child: ElevatedButton(onPressed: () => {context.read<GoogleMapModel>().removeMarkers()}, child: Icon(Icons.location_off_outlined),),),
                    ],),
                  ),) : Container(),
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: option == 'iss'
                                ? () => {
                                      HapticFeedback.mediumImpact(),
                                      Provider.of<GoogleMapModel>(context,
                                              listen: false)
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
                                      Provider.of<GoogleMapModel>(context,
                                              listen: false)
                                          .getIss()
                                    }
                                : null,
                            child: Icon(Icons.satellite))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
