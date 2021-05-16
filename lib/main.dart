import 'package:flutter/material.dart';
import 'package:urbvan_test/viewmodels/google_map_vm.dart';
import 'package:provider/provider.dart';
import 'package:urbvan_test/screens/home.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urbvan Test',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.8),
          title: Center(child:Text('Urbvan Test'),),
        ),
        body: Home()
      ),
    );
  }
}
