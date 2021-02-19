import 'package:flutter/material.dart';

class BasicDivider extends StatelessWidget {
  BasicDivider({this.indent, this.endIndent});
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1.0,
      height: 1.0,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
