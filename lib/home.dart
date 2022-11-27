import 'dart:async';
import 'package:camerafilter/second_screen.dart';
import 'package:intl/intl.dart';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

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

  dynamic pickedDate;
  dynamic pickedMake;
  dynamic pickedMaker;
  dynamic pickedFocal;
  dynamic pickedF;
  dynamic pickedShutter;
  dynamic pickedISO;
  dynamic pickedLens;
  dynamic IntPickedF;

  dynamic IntNum;
  dynamic IntNum2;
  dynamic IntpickedF;
  // dynamic pickedWidth;
  // dynamic pickedHeight;

  // get int_pickedWidth => int.parse(pickedWidth);
  // get int_pickedHeight => int.parse(pickedHeight);

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
    String dateTime = tags["EXIF DateTimeOriginal"].toString();
    String dateMaker = tags["Image Make"].toString();
    String dateMake = tags["Image Model"].toString();
    String dateFocal = tags["EXIF FocalLength"].toString();
    String dateF = tags["EXIF FNumber"].toString();
    String dateShutter = tags["EXIF ExposureTime"].toString();
    String dateISO = tags["EXIF ISOSpeedRatings"].toString();
    String dateLens = tags["EXIF LensModel"].toString();
    // String dateWidth = tags["EXIF ExifImageWidth"].toString();
    // String dateHeight = tags["EXIF ExifImageLength"].toString();
    setState(() {
      if(pickedFile != null ) {
        image = File(pickedFile.path);
        image2 = File(pickedFile.path);
        // final Image =  File(pickedFile.path);
        pickedMaker = dateMaker;
        pickedDate = dateTime.substring(0,16).replaceAll(":", "/").replaceFirst("/", ":", 12);
        //pickedDate = dateTime;
        pickedMake = dateMake;
        pickedFocal = dateFocal;
        pickedF = dateF;
        pickedShutter = dateShutter;
        pickedISO = dateISO;
        pickedLens = dateLens;

        //小数点ありのF値の表示がされないので計算をする
        if(pickedF.length == 3 || pickedF.length == 4 || pickedF.length == 5){
          //３文字の時
          if(pickedF.length == 3) {
            var num1 = pickedF.substring(0,1);
            var num2 = pickedF.substring(2,3);
            //var IntpickedF = num1.parse(num1) / num3.parse(num3);
            IntNum = int.parse(num1);
            IntNum2 = int.parse(num2);
            IntpickedF = IntNum / IntNum2;
            pickedF = IntpickedF.toString();
            return pickedF;
          }
          //4文字の時
          else if (pickedF.length == 4) {
            var num1 = pickedF.substring(0,2);
            var num2 = pickedF.substring(3,4);
            //var IntpickedF = num1.parse(num1) / num3.parse(num3);
            IntNum = int.parse(num1);
            IntNum2 = int.parse(num2);
            IntpickedF = IntNum / IntNum2;
            pickedF = IntpickedF.toString();
            print(IntNum);
            print(num1.runtimeType);
            print(pickedF.runtimeType);
            print("文字数{$pickedF}");
            return pickedF;
          }
          //5文字の時
          else  {
            var num1 = pickedF.substring(0,2);
            var num2 = pickedF.substring(3,5);
            //var IntpickedF = num1.parse(num1) / num3.parse(num3);
            IntNum = int.parse(num1);
            IntNum2 = int.parse(num2);
            IntpickedF = IntNum / IntNum2;
            pickedF = IntpickedF.toString();
            return pickedF;
          }
          // else {
          //   return pickedF;
          // }
        }
        print(pickedF.length);
        print(IntNum);
        print(IntNum2);
        print(pickedF.runtimeType);
        print("文字数{$pickedF}");
        //pickedF = IntPickedF.toString();
        print("!!${pickedF}");
        print(pickedF.runtimeType);
        print("$IntNum");

        // pickedHeight = int.parse(dateHeight, radix: 10);
        // pickedWidth = int.parse(dateWidth ,radix: 10);

        // if ( pickedLens is int){
        //   print("$pickedWidth !!!!");
        // }
        // pickedWidth = dateWidth;
        // pickedHeight = dateHeight;
      }
    });
    // print('latitudeRef: ${tags['GPS GPSLatitudeRef']}');
    // print('latitude: ${tags['GPS GPSLatitude']}');
    // print('longitudeRef: ${tags['GPS GPSLongitudeRef']}');
    // print('longitude: ${tags['GPS GPSLongitude']}');
    print(dateTime.substring(0,16));
    for (final entry in tags.entries) {
      print("${entry.key}: ${entry.value}");
    }
  }

  //保存
  Future saveImage() async {
    if (image != null) {
      final RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 4);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List buffer = byteData!.buffer.asUint8List();
      // LinearProgressIndicator(
      //   valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
      //   semanticsLabel: 'Linear progress indicator',
      // );
      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(buffer));
      if(Platform.isIOS){
        if(result != null){
          toastInfo('保存しました');
        }else{
          toastInfo('保存に失败しました');
        }
      }else{
        if(result != null){
          toastInfo('保存しました');
        }else{
          toastInfo('保存に失败しました');
        }
      }
    }
  }
  toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  //チェックボタン時に次のページに渡す
  //現在は不使用
  void convertWidgetToImage() async {
    final RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 8);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8list = byteData!.buffer.asUint8List();

    final Uint8List buffer = byteData!.buffer.asUint8List();

    Navigator.of(_globalKey.currentContext!).push(MaterialPageRoute(
        builder: (context) => SecondScreen(
          imageData: buffer,
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
          if (image != null) IconButton(
              icon: Icon(Icons.save),
              onPressed: saveImage)
          else Container(),
          //image != null ? IconButton(icon: Icon(Icons.check), onPressed: convertWidgetToImage) : Text(""),
        ],

      ),
      backgroundColor: Colors.white60,
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
            if (image != null) RepaintBoundary(
              key: _globalKey,
              child: Container(
                color: Colors.white,
                child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 9,
                          child: Container(
                            child: Center(
                              child: Image.file(
                                  image,
                                  fit: BoxFit.contain
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                pickedDate == "null" ? Container(
                                  child: Text(""),
                                ) : Text("$pickedDate", style: TextStyle(fontSize: 9),),
                                pickedMake != "null" ? Container(
                                  child: Text("$pickedMake", style: TextStyle(fontSize: 10),),
                                ) : Container(),
                              ],
                            ),
                            Row(
                              children: [
                                if (pickedMaker == "SONY") Container(
                                  width: 50,
                                  child: Image.asset(
                                    'images/sony.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (pickedMaker == "NIKON CORPORATION") Container(
                                  width: 50,
                                  child: Image.asset(
                                    'images/Nikon.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (pickedMaker == "Canon") Container(
                                  width: 50,
                                  child: Image.asset(
                                    'images/Canon.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (pickedMaker == "Apple") Container(
                                  width: 50,
                                  child: Image.asset(
                                    'images/apple.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (pickedMaker == "Panasonic") Container(
                                  width: 50,
                                  child: Image.asset(
                                    'images/Panasonic.png',
                                    fit: BoxFit.cover,
                                  ),
                                )
                                // if (pickedMaker == "FUJIFILM") Container(
                                //   width: 50,
                                //   child: Image.asset(
                                //     'images/Fujifilm.png',
                                //     //fit: BoxFit.cover,
                                //   ),
                                // )
                                else Container(),
                                //Appleの時にロゴを右に寄せる
                                pickedMaker == "Apple" ? Container(): SizedBox(width: 10),
                                //Appleの時にレンズ情報の非表示
                                pickedMaker == "Apple" ? Container():
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 10,),
                                      Row(
                                        //mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          //SizedBox(width: 7),
                                          pickedShutter == "null" ? Container(
                                            child: Text(""),
                                          ) : Text("$pickedShutter""ss", style: TextStyle(fontSize: 10),),
                                          SizedBox(width: 7,),
                                          pickedF == "null" ? Container(
                                            child: Text(""),
                                          ) : Text("f$pickedF", style: TextStyle(fontSize: 10),),
                                          SizedBox(width: 7,),
                                          pickedISO == "null" ? Container(
                                            child: Text(""),
                                          ) : Text("iso$pickedISO", style: TextStyle(fontSize: 10),),
                                        ],
                                      ),
                                      Column(
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          pickedLens == "null" || pickedMaker == "Apple" || pickedLens == "DT 0mm F0 SAM" ? Container(
                                            //child: Container(),
                                          ) : Text("$pickedLens", style: TextStyle(fontSize: 10),),
                                          //SizedBox(width: 6,),
                                          // pickedFocal == "null" ? Container(
                                          //   child: Text(""),
                                          // ) : Text("$pickedFocal""mm", style: TextStyle(fontSize: 10),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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