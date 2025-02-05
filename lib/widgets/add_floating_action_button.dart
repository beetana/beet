import 'package:beet/constants.dart';
import 'package:flutter/material.dart';

class AddFloatingActionButton extends StatelessWidget {
  final Function()? onPressed;

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
            padding: const EdgeInsets.only(
              right: 16.0,
              bottom: 16.0,
            ),
            child: RawMaterialButton(
              elevation: 6.0,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              constraints: const BoxConstraints.tightFor(
                width: 56.0,
                height: 56.0,
              ),
              shape: const CircleBorder(),
              fillColor: kPrimaryColor,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
