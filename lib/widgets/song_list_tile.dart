import 'package:beet/objects/song.dart';
import 'package:beet/utilities/constants.dart';
import 'package:flutter/material.dart';

class SongListTile extends StatelessWidget {
  final Song song;
  final bool isVisible;
  final Function checkboxCallback;
  final Function tileTappedCallback;

  SongListTile({
    @required this.song,
    @required this.isVisible,
    @required this.checkboxCallback,
    @required this.tileTappedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        song.title,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Visibility(
        visible: isVisible,
        child: Text('${song.playingTime}分'),
      ),
      trailing: Visibility(
        visible: isVisible,
        child: Checkbox(
          activeColor: kPrimaryColor,
          value: song.checkboxState,
          onChanged: checkboxCallback,
        ),
      ),
      onTap: tileTappedCallback,
    );
  }
}
