import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import 'Painter.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey _globalKey = new GlobalKey();
  final picker = ImagePicker();
  PaintController _controller = PaintController();

  _insertImgintoGallery() async {
    RenderRepaintBoundary boundaryForLogoImg = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image imageForLogoImg = await boundaryForLogoImg.toImage();

    ByteData byteData = await imageForLogoImg.toByteData(format: ui.ImageByteFormat.png) as ByteData;
    final result = await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),

    body: Stack(
      children: <Widget>[
        RepaintBoundary(
            key: _globalKey,
          child: Container(
          child: Painter(
            paintController: _controller,
          ),
          ),
        )
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _insertImgintoGallery(),
      child: Icon(Icons.file_download),
    ), // This trailing comma makes auto-formatting nicer for build methods.
  );
}
}