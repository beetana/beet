import 'package:beet/constants.dart';
import 'package:flutter/material.dart';

class AddFloatingActionButton extends StatelessWidget {
  final Function onPressed;

  AddFloatingActionButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
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
              fillColor: kPrimaryColor,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
