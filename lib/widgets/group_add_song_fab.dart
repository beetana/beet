import 'package:flutter/material.dart';

class GroupAddSongFAB extends StatelessWidget {
  GroupAddSongFAB({this.onPressed});
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 16.0,
        bottom: 16.0,
      ),
      child: RawMaterialButton(
          elevation: 6.0,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          constraints: BoxConstraints.tightFor(
            width: 56.0,
            height: 56.0,
          ),
          shape: CircleBorder(),
          fillColor: Colors.cyan,
          onPressed: onPressed),
    );
  }
}
