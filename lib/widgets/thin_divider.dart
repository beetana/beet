import 'package:flutter/material.dart';

class ThinDivider extends StatelessWidget {
  final double indent;
  final double endIndent;

  ThinDivider({this.indent, this.endIndent});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 0.5,
      height: 0.5,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
