import 'package:flutter/material.dart';

/// プロジェクトで共通して使用するAppBar。デフォルトでは56ptのheightを48ptにしてある。
class SizedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final double height;

  SizedAppBar({
    required this.title,
    this.actions,
    this.leading,
    this.height = 48,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: AppBar(
        title: Text(title),
        actions: actions,
        leading: leading,
      ),
    );
  }
}
