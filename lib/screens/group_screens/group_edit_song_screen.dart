import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_edit_song_model.dart';
import 'package:beet/objects/song.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupEditSongScreen extends StatelessWidget {
  GroupEditSongScreen({this.groupId, this.song});
  final String groupId;
  final Song song;
  final songTitleController = TextEditingController();
  final songMemoController = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final timePickerController =
        FixedExtentScrollController(initialItem: song.playingTime);
    songTitleController.text = song.title;
    songMemoController.text = song.memo;
    return ChangeNotifierProvider<GroupEditSongModel>(
      create: (_) => GroupEditSongModel()..init(groupId: groupId, song: song),
      child: Consumer<GroupEditSongModel>(builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text('曲を編集'),
                  actions: [
                    TextButton(
                      child: Text(
                        '保存',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        model.startLoading();
                        try {
                          await model.editSong();
                          Navigator.pop(context);
                        } catch (e) {
                          showMessageDialog(context, e.toString());
                        }
                        model.endLoading();
                      },
                    ),
                  ],
                ),
                body: Scrollbar(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          TextField(
                            controller: songTitleController,
                            decoration: InputDecoration(
                              hintText: 'タイトル',
                              border: InputBorder.none,
                              suffix: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.black54,
                                ),
                                onPressed: () {
                                  songTitleController.clear();
                                  model.songTitle = '';
                                },
                              ),
                            ),
                            onChanged: (text) {
                              model.songTitle = text;
                            },
                          ),
                          BasicDivider(),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '演奏時間',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    color: kSlightlyTransparentPrimaryColor,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 72.0,
                                      width: 48.0,
                                      child: CupertinoPicker(
                                        scrollController: timePickerController,
                                        itemExtent: 27.0,
                                        magnification: 1.2,
                                        useMagnifier: true,
                                        onSelectedItemChanged: (index) {
                                          model.songPlayingTime =
                                              model.songPlayingTimes[index];
                                        },
                                        children: model.songPlayingTimes
                                            .map(
                                              (value) => Text(
                                                '$value',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      '分',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: kSlightlyTransparentPrimaryColor,
                                      ),
                                    ),
                                    SizedBox(width: 36.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          BasicDivider(),
                          NotificationListener<ScrollNotification>(
                            onNotification: (_) => true,
                            child: Scrollbar(
                              child: TextField(
                                controller: songMemoController,
                                maxLines: 8,
                                decoration: InputDecoration(
                                  hintText: 'メモ',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(0.0),
                                ),
                                onTap: () async {
                                  await Future.delayed(
                                    Duration(milliseconds: 100),
                                  );
                                  scrollController.jumpTo(scrollController
                                      .position.maxScrollExtent);
                                },
                                onChanged: (text) {
                                  model.songMemo = text;
                                },
                              ),
                            ),
                          ),
                          BasicDivider(),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              model.isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        );
      }),
    );
  }
}
