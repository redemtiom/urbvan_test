import 'package:flutter/material.dart';
import 'package:urbvan_test/map.dart';
import 'package:urbvan_test/viewmodels/google_map_vm.dart';
import 'package:provider/provider.dart';
//import 'package:urbvan_test/viewmodels/google_map_vm.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            MapG(lat: 19.430751, lng: -99.133064),
            SafeArea(
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () => {}, child: Icon(Icons.alt_route)),
                    SizedBox(
                      width: 10.0,
                    ),
                    ElevatedButton(
                        onPressed: () => {}, child: Icon(Icons.satellite))
                  ],
                ),
              ),
            )
          ],
          alignment: AlignmentDirectional.bottomCenter,
        ),
      ),
    );
  }
}
