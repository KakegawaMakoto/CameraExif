import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SecondScreen extends StatelessWidget {
  final Uint8List imageData;

  const SecondScreen({Key? key, required this.imageData}) : super(key: key);

  //保存
  Future saveImage() async {
    if (imageData != null) {
      // Uint8List buffer = await imageData!.readAsBytesSync();
      await ImageGallerySaver.saveImage(
          imageData,
          quality: 100,
      );
      toastInfo("画像を保存しました");
    }
  }
  toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Camera Exif",
        ),
        backgroundColor: Colors.black12,
        // leading: IconButton(icon: Icon(Icons.clear), onPressed: clearimage),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: saveImage),
        ],

      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxHeight: size.width, maxWidth: size.width),
          child: Image.memory(
            imageData,
            width: size.width,
            height: size.height,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}



