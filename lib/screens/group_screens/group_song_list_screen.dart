import 'package:beet/models/group_models/group_song_list_model.dart';
import 'package:beet/screens/group_screens/group_add_song_screen.dart';
import 'package:beet/screens/group_screens/group_set_list_screen.dart';
import 'package:beet/screens/group_screens/group_song_screen.dart';
import 'package:beet/widgets/add_floating_action_button.dart';
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
                        FlatButton.icon(
                          icon: model.buttonIcon,
                          label: model.buttonText,
                          onPressed: () {
                            model.changeMode();
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemExtent: 60.0,
                      itemCount: model.songList.length,
                      itemBuilder: (context, index) {
                        final song = model.songList[index];
                        return SongListTile(
                          songTitle: song.title,
                          songMinute: song.playingTime.toString(),
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
                                  builder: (context) => GroupSongScreen(
                                    groupID: groupID,
                                    song: song,
                                  ),
                                ),
                              );
                              model.getSongList(groupID);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: model.isSetListMode,
                    child: SizedBox(
                      height: 40.0,
                    ),
                  ),
                ],
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      visible: model.isSetListMode,
                      child: Divider(
                        thickness: 1.0,
                        height: 1.0,
                      ),
                    ),
                    Visibility(
                      visible: model.isSetListMode,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 40.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('${model.songNum} 曲'),
                                  Text('${model.totalPlayTime} 分'),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 40.0,
                            child: VerticalDivider(
                              thickness: 0.2,
                              width: 0.2,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 40.0,
                              child: FlatButton(
                                child: Text(
                                  '決定',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 17.0,
                                  ),
                                ),
                                onPressed: () async {
                                  List<String> setList = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GroupSetListScreen(
                                        selectedSongs: model.selectedSongs,
                                        songNum: model.songNum,
                                        totalPlayTime: model.totalPlayTime,
                                        groupID: groupID,
                                      ),
                                    ),
                                  );
                                  model.selectedSongs = setList;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !model.isSetListMode,
                      child: AddFloatingActionButton(
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
              ),
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
                child: Text('曲が登録されていません'),
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    AddFloatingActionButton(
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
