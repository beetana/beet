import 'package:flutter/material.dart';

class SetListTile extends StatelessWidget {
  final String item;
  final String songNum;

  SetListTile({
    this.item,
    this.songNum,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        '$songNum $item',
        style: TextStyle(fontSize: 20.0),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
