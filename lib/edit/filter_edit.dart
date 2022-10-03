import 'dart:io';
import 'package:camerafilter/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditPage extends StatefulWidget {
  EditPage(this.base64string);
  final String base64string;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  // String get image => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   "Image Filters",
        // ),
        backgroundColor: Colors.black12,
        // actions: [IconButton(icon: Icon(Icons.check),
        //     onPressed:
        // )],
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        // child: Image.memory(
        //     imageData,
        //     fit: BoxFit.cover,
        // )
        // child: Ink.image(image: ),
      ),
    );
  }
}
