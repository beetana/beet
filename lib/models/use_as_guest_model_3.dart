import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:beet/objects/mc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class UseAsGuestModel3 extends ChangeNotifier {
  List<String> setList = [];
  List<String> songsNumText = [];
  final GlobalKey globalKey = GlobalKey();

  void init({List<dynamic> setList}) {
    int num = 1;
    setList.forEach((item) {
      if (item is MC) {
        this.setList.add(item.title);
        this.songsNumText.add('    ');
      } else {
        this.setList.add(item);
        this.songsNumText.add(num < 10 ? '  $num.' : '$num.');
        num += 1;
      }
    });
    notifyListeners();
  }

  Future saveSetListImage() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    await ImageGallerySaver.saveImage(pngBytes);
    notifyListeners();
  }
}
