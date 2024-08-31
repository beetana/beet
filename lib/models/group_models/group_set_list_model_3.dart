import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:beet/objects/set_list.dart';
import 'package:beet/objects/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class GroupSetListModel3 extends ChangeNotifier {
  List<String> setList = [];
  List<String> songsNumText = [];
  final GlobalKey globalKey = GlobalKey();

  // 引数のsetListの中身はSongもしくはMC
  void init({required List<SetList> setList}) {
    int num = 1;

    setList.forEach((item) {
      this.setList.add(item.title);
      if (item is Song) {
        // 曲のタイトルの位置を揃えるために10未満の時だけスペースを入れる
        songsNumText.add(num < 10 ? '  $num.' : '$num.');
        num += 1;
      } else {
        songsNumText.add('    ');
      }
    });
    notifyListeners();
  }

  // globalKeyを持っているWidget(この場合はセットリストの部分)を画像として端末に保存する
  // https://www.egao-inc.co.jp/programming/flutter-convert-widget-to-image/
  Future<void> saveSetListImage() async {
    final boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    // pixelRatioの値はバランス的にとりあえず3.0とする。必要に応じて変更可。
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    await ImageGallerySaver.saveImage(pngBytes);
    notifyListeners();
  }
}
