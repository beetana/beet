import 'package:beet/models/group_models/group_song_edit_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSongEditScreen extends StatelessWidget {
  GroupSongEditScreen(
      {this.groupID, this.songID, this.songTitle, this.songPlayTime});
  final String groupID;
  final String songID;
  final String songTitle;
  final int songPlayTime;
  final songTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSongEditModel>(
      create: (_) => GroupSongEditModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('曲を編集'),
        ),
        body: Consumer<GroupSongEditModel>(builder: (context, model, child) {
          final timePickerController =
              FixedExtentScrollController(initialItem: songPlayTime);
          songTitleController.text = songTitle;
          model.songTitle = songTitle;
          model.playingTime = songPlayTime;
          return Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: songTitleController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'タイトル',
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
                    SizedBox(
                      height: 32.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            '演奏時間',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Container(
                            height: 96.0,
                            width: 56.0,
                            child: CupertinoPicker(
                              scrollController: timePickerController,
                              itemExtent: 32.0,
                              magnification: 1.2,
                              useMagnifier: true,
                              onSelectedItemChanged: (index) {
                                model.playingTime = model.playingTimes[index];
                              },
                              children: model.playingTimes
                                  .map((value) => Text('$value'))
                                  .toList(),
                            ),
                          ),
                          Text(
                            '分',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    RaisedButton(
                      child: Text('OK'),
                      onPressed: () async {
                        model.startLoading();
                        try {
                          await model.editSong(
                            groupID: groupID,
                            songID: songID,
                          );
                          await _showTextDialog(context, '変更しました');
                          Navigator.pop(context);
                        } catch (e) {
                          _showTextDialog(context, e.toString());
                        }
                        model.endLoading();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        '削除',
                      ),
                      onPressed: () async {
                        bool isDelete =
                            await _confirmDeleteDialog(context, '削除しますか？');
                        if (isDelete == true) {
                          model.startLoading();
                          try {
                            await model.deleteSong(
                              groupID: groupID,
                              songID: songID,
                            );
                            await _showTextDialog(context, '削除しました');
                            Navigator.pop(context);
                          } catch (e) {
                            _showTextDialog(context, e.toString());
                          }
                          model.endLoading();
                        }
                      },
                    )
                  ],
                ),
              ),
              model.isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox()
            ],
          );
        }),
      ),
    );
  }
}

Future _showTextDialog(context, message) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

Future _confirmDeleteDialog(context, message) async {
  bool _isDelete;
  _isDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('キャンセル'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text('削除'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
  return _isDelete;
}
