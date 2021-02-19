import 'package:flutter/material.dart';

class ThinDivider extends StatelessWidget {
  ThinDivider({this.indent, this.endIndent});
  final double indent;
  final double endIndent;

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
