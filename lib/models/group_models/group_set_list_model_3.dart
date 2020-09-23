import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class GroupSetListModel3 extends ChangeNotifier {
  Image setListImage;
  bool isLoading = false;
  final GlobalKey globalKey = GlobalKey();

  Future createImage() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    setListImage = Image.memory(pngBytes);
//    await ImageGallerySaver.saveImage(pngBytes);
//    var base64 = base64Encode(pngBytes);
//    print(base64);
    notifyListeners();
  }
}
