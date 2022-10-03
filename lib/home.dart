import 'package:camerafilter/edit/filter_edit.dart';
import 'package:camerafilter/second_screen.dart';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:camerafilter/filters.dart';
import 'package:image_size_getter/file_input.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';//　File
import 'dart:typed_data'; // Uint8List
import 'package:image_size_getter/image_size_getter.dart';


import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key }) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //変数の宣言
  File? image;
  File? image2;
  dynamic imageSave;
  final picker = ImagePicker();
  final GlobalKey _globalKey = GlobalKey();
  String imagePath = '';
  final List<List<double>> filters = [SEPIA_MATRIX, GREYSCALE_MATRIX , VINTAGE_MATRIX, SWEET_MATRIX];

  dynamic pickedDate;
  dynamic pickedMake;
  dynamic pickedFocal;
  dynamic pickedF;
  dynamic pickedShutter;
  dynamic pickedISO;
  dynamic pickedLens;

  var dateTime;
  var dateMake;
  var dateFocal;





  // void convertWidgetToImage() async {
  //   RenderObject? repaintBoundary = _globalKey.currentContext!.findRenderObject();
  //     ui.Image boxImage = (await repaintBoundary!) as ui.Image;
  //   ByteData? byteData = await boxImage.toByteData(format: ui.ImageByteFormat.png);
  //   Uint8List uint8list = byteData!.buffer.asUint8List();
  //   // Navigator.of(_globalKey.currentContext).push(MaterialPageRoute(
  //   //     builder: (context) => SecondScreen(
  //   //       imageData: uint8list,
  //   //     )));
  // }

  //削除
  void clearimage() {
    setState(() {
      image = null;
      image2 = null;
    });
  }

  //カメラで撮影した画像を取得する命令
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(pickedFile != null) {
        image = File(pickedFile.path);
        image2 = File(pickedFile.path);
      }
    });
  }

  //端末のアルバムに保存されている画像とExifデータ取得
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    //Exif取得
    final tags = await readExifFromBytes(await File(pickedFile!.path).readAsBytes());
    // final tags = await readExifFromBytes(await image!.readAsBytes());
    String dateTime = tags["Image DateTime"].toString();
    String dateMake = tags["Image Model"].toString();
    String dateFocal = tags["EXIF FocalLength"].toString();
    String dateF = tags["EXIF FNumber"].toString();
    String dateShutter = tags["EXIF ExposureTime"].toString();
    String dateISO = tags["EXIF ISOSpeedRatings"].toString();
    String dateLens = tags["EXIF LensModel"].toString();
    setState(() {
      if(pickedFile != null) {
        image = File(pickedFile.path);
        image2 = File(pickedFile.path);
        // final Image =  File(pickedFile.path);
        pickedDate = dateTime;
        pickedMake = dateMake;
        pickedFocal = dateFocal;
        pickedF = dateF;
        pickedShutter = dateShutter;
        pickedISO = dateISO;
        pickedLens = dateLens;
      }
    });
    // print('latitudeRef: ${tags['GPS GPSLatitudeRef']}');
    // print('latitude: ${tags['GPS GPSLatitude']}');
    // print('longitudeRef: ${tags['GPS GPSLongitudeRef']}');
    // print('longitude: ${tags['GPS GPSLongitude']}');
    // print(dateTime);
    for (final entry in tags.entries) {
      print("${entry.key}: ${entry.value}");
    }
  }


  //保存
  Future saveImage() async {
    if (image2 != null) {

      final RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 5);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List buffer = byteData!.buffer.asUint8List();

      print(boundary.size);
      await ImageGallerySaver.saveImage(buffer);
      toastInfo("画像を保存しました");
    }
  }
  toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  void convertWidgetToImage() async {
    final RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 5);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8list = byteData!.buffer.asUint8List();
    Navigator.of(_globalKey.currentContext!).push(MaterialPageRoute(
        builder: (context) => SecondScreen(
          imageData: uint8list,
        )));
  }


  @override
  Widget build(BuildContext context) {
    // final size = ImageSizeGetter.getSize(FileInput(image2!));
    // final width = size.height;
    // final height = size.width;
    final File? image = image2;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Camera Exif",
        ),
        backgroundColor: Colors.black12,
        leading: image != null ? IconButton(icon: Icon(Icons.clear), onPressed: clearimage) : null,
        actions: [
          image != null ? IconButton(icon: Icon(Icons.save), onPressed: saveImage) : Container(),
          // image != null ? IconButton(icon: Icon(Icons.check), onPressed: convertWidgetToImage) : Text(""),
        ],

      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //呼び出しボタン
            image == null ? ElevatedButton(
                onPressed: () {
                  getImageFromCamera();
                },
                child: const Text('カメラから画像を取得')
            )
            : Text(""),
            // const SizedBox(height: 5),
            //呼び出しボタン
            image == null ? ElevatedButton(
                onPressed: () {
                  getImageFromGallery();
                },
                child: const Text('アルバムから画像を取得')
            )
            : Container(),
            // const SizedBox(height: 5),
            //取得した画像を表示
             image == null ? const Text('画像が選択されてません') : Container(
              // child: Expanded(flex:1,child: Image.file(image, fit: BoxFit.cover)),
            ),
            // SizedBox(height: 10,),
            if (image != null) Expanded(
              flex: 5,
              child: RepaintBoundary(
                key: _globalKey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        child: Expanded(
                          flex: 1,
                          child: Image.file(
                              image2!,
                              fit: BoxFit.scaleDown
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      pickedDate == null ? Container(
                        child: Text(""),
                      ) : Text("$pickedDate"),
                      pickedMake != null ? Container(
                        child: Text("$pickedMake"),
                      ) : Container(),
                      pickedFocal == null ? Container(
                        child: Text(""),
                      ) : Text("$pickedFocal mm"),
                      pickedShutter == null ? Container(
                        child: Text(""),
                      ) : Text("$pickedShutter"),
                      pickedF == null ? Container(
                        child: Text(""),
                      ) : Text("f $pickedF"),
                      pickedISO == null ? Container(
                        child: Text(""),
                      ) : Text("iso $pickedISO"),
                      if (pickedLens.isEmpty) Container(
                        child: Text(""),
                      ) else Text("$pickedLens"),
                    ],
                  ),
                ),
              ),
            ) else Container(),
            // SizedBox(height: 50,)
            // image != null ? Container(
            //   child: pickedDate != null
            //       ?Text("$pickedDate")
            //       :Text("")
            // )
            //     : Text("")
          ],
        ),
      ),
    );
  }
}
//
// child: RepaintBoundary(
// key: _globalKey,
// child: Container(
// constraints: BoxConstraints(
// maxWidth: size.width,
// maxHeight: size.width,
// ),
// child: PageView.builder(
// itemCount: filters.length,
// itemBuilder: (context, index) {
// return ColorFiltered(
// colorFilter: ColorFilter.matrix(filters[index]),
// child: image,
// );
// }),
// ),
// ),