import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_song_list_model.dart';
import 'package:beet/screens/group_screens/group_add_song_screen.dart';
import 'package:beet/screens/group_screens/group_set_list_screen.dart';
import 'package:beet/screens/group_screens/group_song_screen.dart';
import 'package:beet/widgets/add_floating_action_button.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/song_list_tile.dart';
import 'package:beet/widgets/thin_divider.dart';
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
                  ThinDivider(),
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemExtent: 60.0,
                        itemCount: model.songList.length + 1,
                        itemBuilder: (context, index) {
                          if (index < model.songList.length) {
                            final song = model.songList[index];
                            return SongListTile(
                              songTitle: song.title,
                              songMinute: song.playingTime.toString(),
                              isChecked: song.checkboxState,
                              isVisible: model.isSetListMode,
                              checkboxCallback: (value) {
                                model.selectSong(song);
                              },
                              tileTappedCallback: () async {
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
                              },
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: model.isSetListMode,
                    child: ThinDivider(),
                  ),
                  Visibility(
                    visible: model.isSetListMode,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('${model.songNum} 曲'),
                              Text('${model.totalPlayTime} 分'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: FlatButton(
                              onPressed: model.selectedSongs.isEmpty
                                  ? null
                                  : () async {
                                      List<String> setList =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GroupSetListScreen(
                                            selectedSongs: model.selectedSongs,
                                            songNum: model.songNum,
                                            totalPlayTime: model.totalPlayTime,
                                            groupID: groupID,
                                          ),
                                        ),
                                      );
                                      model.selectedSongs = setList;
                                    },
                              child: Text(
                                '決定',
                                style: TextStyle(
                                  color: model.selectedSongs.isEmpty
                                      ? kInvalidEnterButtonColor
                                      : kEnterButtonColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
