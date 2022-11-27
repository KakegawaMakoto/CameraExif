import 'package:flutter/material.dart';
import 'package:camerafilter/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CameraExif',
        debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: Colors.black12,
      ),
      home: const MyHomePage(),
    );
  }
}
