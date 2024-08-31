import 'package:flutter/material.dart';

class SetListTile extends StatelessWidget {
  final String item;
  final String songNum;
  final double fontSize;
  final double padding;

  SetListTile({
    required this.item,
    required this.songNum,
    required this.fontSize,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Text(
        '$songNum $item',
        style: TextStyle(fontSize: fontSize),
        overflow: TextOverflow.ellipsis,
        textScaleFactor: 1.0,
      ),
    );
  }
}
