import 'package:flutter/material.dart';

class SongListTile extends StatelessWidget {
  final String songTitle;
  final String songMinute;
  final bool isChecked;
  final bool isVisible;
  final Function checkboxCallback;
  final Function tileTappedCallback;

  SongListTile(
      {this.songTitle,
      this.songMinute,
      this.isChecked,
      this.isVisible,
      this.checkboxCallback,
      this.tileTappedCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(songTitle),
      subtitle: Visibility(
        visible: isVisible,
        child: Text('$songMinute分'),
      ),
      trailing: Visibility(
        visible: isVisible,
        child: Checkbox(
          activeColor: Colors.cyan,
          value: isChecked,
          onChanged: checkboxCallback,
        ),
      ),
      onTap: tileTappedCallback,
    );
  }
}
