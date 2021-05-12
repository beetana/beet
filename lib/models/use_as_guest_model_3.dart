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

  // 引数のsetListの中身はMCもしくはString
  void init({List<dynamic> setList}) {
    int num = 1;

    setList.forEach((item) {
      if (item is MC) {
        this.setList.add(item.title);
        songsNumText.add('    ');
      } else {
        this.setList.add(item);
        // 曲のタイトルの位置を揃えるために10未満の時だけスペースを入れる
        songsNumText.add(num < 10 ? '  $num.' : '$num.');
        num += 1;
      }
    });
    notifyListeners();
  }

  // globalKeyを持っているWidget(この場合はセットリストの部分)を画像として端末に保存する
  // https://www.egao-inc.co.jp/programming/flutter-convert-widget-to-image/
  Future<void> saveSetListImage() async {
    final RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    // pixelRatioの値はバランス的にとりあえず3.0とする。必要に応じて変更可。
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData.buffer.asUint8List();
    await ImageGallerySaver.saveImage(pngBytes);
    notifyListeners();
  }
}
