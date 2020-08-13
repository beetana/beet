import 'package:beet/models/group_models/group_song_list_model.dart';
import 'package:beet/screens/group_screens/add_song_screen.dart';
import 'package:beet/widgets/song_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSongListScreen extends StatelessWidget {
  GroupSongListScreen({this.groupID});
  final String groupID;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSongListModel>(
      create: (_) => GroupSongListModel()..getSongList(groupID),
      child: Consumer<GroupSongListModel>(builder: (context, model, child) {
        return Column(
          children: <Widget>[
            FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.playlist_add,
                    color: Colors.black54,
                  ),
                  Text('セットリストを作成'),
                ],
              ),
              onPressed: () {
                model.changeMode();
              },
            ),
            Flexible(
              child: ListView.builder(
                  physics: ScrollPhysics(),
                  itemCount: model.songList.length,
                  itemBuilder: (context, index) {
                    final song = model.songList[index];
                    return SongListTile(
                      songTitle: song.title,
                      songMinute: song.playTime.toString(),
                      isChecked: song.checkboxState,
                      isVisible: model.isSetListMode,
                      checkboxCallback: (state) {
                        model.toggleCheck(song);
                      },
                      tileTappedCallback: () {
                        if (model.isSetListMode == true) {
                          model.toggleCheck(song);
                        }
                      },
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
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
                    fillColor: Colors.blueGrey,
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddSongScreen(groupID: groupID),
                          fullscreenDialog: true,
                        ),
                      );
                      model.getSongList(groupID);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
