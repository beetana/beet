import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:beet/objects/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class GroupSetListModel3 extends ChangeNotifier {
  List<String> setList = [];
  List<String> songsNumText = [];
  final GlobalKey globalKey = GlobalKey();

  void init({List<dynamic> setList}) {
    int num = 1;
    setList.forEach((item) {
      if (item is Song) {
        this.setList.add(item.title);
        songsNumText.add(num < 10 ? '  $num.' : '$num.');
        num += 1;
      } else {
        this.setList.add(item.title);
        songsNumText.add('    ');
      }
    });
    notifyListeners();
  }

  Future<void> saveSetListImage() async {
    final RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData.buffer.asUint8List();
    await ImageGallerySaver.saveImage(pngBytes);
    notifyListeners();
  }
}
