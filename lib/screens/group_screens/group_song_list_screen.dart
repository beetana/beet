import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_song_list_model.dart';
import 'package:beet/screens/group_screens/group_add_song_screen.dart';
import 'package:beet/screens/group_screens/group_set_list_screen.dart';
import 'package:beet/screens/group_screens/group_song_details_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/add_floating_action_button.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/song_list_tile.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSongListScreen extends StatelessWidget {
  final String groupId;
  final double textScale;

  GroupSongListScreen({this.groupId, this.textScale});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSongListModel>(
      create: (_) => GroupSongListModel()..init(groupId: groupId),
      child: Consumer<GroupSongListModel>(builder: (context, model, child) {
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
                      TextButton.icon(
                        icon: model.buttonIcon,
                        label: model.buttonText,
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: () {
                          model.changeMode();
                        },
                      ),
                    ],
                  ),
                ),
                BasicDivider(),
                Expanded(
                  child: Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        try {
                          await model.fetchSongs();
                        } catch (e) {
                          showMessageDialog(context, e.toString());
                        }
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemExtent: 52.0 * textScale,
                        // ListTileとFABが被らないよう一つ余分にitemを作ってSizedBoxを返す
                        itemCount: model.songs.length + 1,
                        itemBuilder: (context, index) {
                          if (index < model.songs.length) {
                            final song = model.songs[index];
                            return SongListTile(
                              song: song,
                              isVisible: model.isSetListMode,
                              checkboxCallback: (value) {
                                model.selectSong(song: song);
                              },
                              tileTappedCallback: () async {
                                if (model.isSetListMode) {
                                  // セットリストを一枚の画像にバランス良く収めるための上限が14曲
                                  model.setList.length >= 14 && !song.checkboxState
                                      ? showMessageDialog(
                                          context,
                                          '作成できるセットリストは14曲まで(MC含む)です。',
                                        )
                                      : model.selectSong(song: song);
                                } else {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GroupSongDetailsScreen(
                                        groupId: groupId,
                                        song: song,
                                      ),
                                    ),
                                  );
                                  try {
                                    await model.fetchSongs();
                                  } catch (e) {
                                    showMessageDialog(context, e.toString());
                                  }
                                }
                              },
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
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
                            Text('${model.songCount} 曲'),
                            Text('${model.totalPlayTime} 分'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: TextButton(
                            child: Text(
                              '決定',
                              style: TextStyle(
                                color: model.setList.isEmpty
                                    ? kInvalidEnterButtonColor
                                    : kEnterButtonColor,
                                fontSize: 16.0,
                              ),
                            ),
                            onPressed: model.setList.isEmpty
                                ? null
                                : () async {
                                    // 曲を選び直すためにこの画面に戻ってきた際、
                                    // 作成途中のセットリストがここに入る
                                    List<dynamic> returnedSetList =
                                        await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GroupSetListScreen(
                                          setList: model.setList,
                                          groupId: groupId,
                                        ),
                                      ),
                                    );
                                    model.reselectSongs(setList: returnedSetList);
                                  },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: !model.isSetListMode,
              child: AddFloatingActionButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupAddSongScreen(groupId: groupId),
                      fullscreenDialog: true,
                    ),
                  );
                  try {
                    await model.fetchSongs();
                  } catch (e) {
                    showMessageDialog(context, e.toString());
                  }
                },
              ),
            ),
            model.isLoading
                ? Container(
                    color: Colors.transparent,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : model.songs.isEmpty
                    ? const Center(
                        child: Text('曲が登録されていません'),
                      )
                    : const SizedBox(),
          ],
        );
      }),
    );
  }
}
