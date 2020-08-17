import 'package:beet/models/group_models/group_song_list_model.dart';
import 'package:beet/screens/group_screens/group_add_song_screen.dart';
import 'package:beet/screens/group_screens/group_set_list_screen.dart';
import 'package:beet/screens/group_screens/group_song_edit_screen.dart';
import 'package:beet/widgets/group_add_song_fab.dart';
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
        if (model.songList.isNotEmpty) {
          return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: model.buttonAlignment,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        FlatButton(
                          child: Row(
                            children: <Widget>[
                              model.buttonIcon,
                              model.buttonText,
                            ],
                          ),
                          onPressed: () {
                            model.changeMode();
                          },
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                        physics: ScrollPhysics(),
                        itemExtent: 70.0,
                        itemCount: model.songList.length,
                        itemBuilder: (context, index) {
                          final song = model.songList[index];
                          return SongListTile(
                            songTitle: song.title,
                            songMinute: song.playTime.toString(),
                            isChecked: song.checkboxState,
                            isVisible: model.isSetListMode,
                            checkboxCallback: (state) {
                              model.selectSong(song);
                            },
                            tileTappedCallback: () async {
                              if (model.isSetListMode == true) {
                                model.selectSong(song);
                              } else {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GroupSongEditScreen(
                                      groupID: groupID,
                                      songID: song.songID,
                                      songTitle: song.title,
                                      songPlayTime: song.playTime,
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                );
                                model.getSongList(groupID);
                              }
                            },
                          );
                        }),
                  ),
                  Visibility(
                    visible: model.isSetListMode,
                    child: SizedBox(
                      height: 30.0,
                    ),
                  ),
                ],
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Visibility(
                          visible: model.isSetListMode,
                          child: Expanded(
                            flex: 3,
                            child: Container(
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(18.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    '${model.songNum} 曲',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '${model.totalPlayTime} 分',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: model.isSetListMode,
                          child: Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.cyan,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(18.0),
                                  ),
                                ),
                                height: 40.0,
                                child: FlatButton(
                                  child: Text(
                                    '作成',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GroupSetListScreen(
                                          setList: model.selectedSongs,
                                          songNum: model.songNum,
                                          totalPlayTime: model.totalPlayTime,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: !model.isSetListMode,
                      child: GroupAddSongFAB(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GroupAddSongScreen(groupID: groupID),
                              fullscreenDialog: true,
                            ),
                          );
                          model.getSongList(groupID);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        } else if (model.isLoading == true) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Stack(
            children: <Widget>[
              Center(
                child: Text('曲がありません'),
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    GroupAddSongFAB(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GroupAddSongScreen(groupID: groupID),
                            fullscreenDialog: true,
                          ),
                        );
                        model.getSongList(groupID);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
