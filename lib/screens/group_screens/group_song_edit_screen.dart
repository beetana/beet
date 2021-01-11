import 'package:beet/models/group_models/group_song_edit_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSongEditScreen extends StatelessWidget {
  GroupSongEditScreen(
      {this.groupID, this.songID, this.songTitle, this.songPlayingTime});
  final String groupID;
  final String songID;
  final String songTitle;
  final int songPlayingTime;
  final songTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final timePickerController =
        FixedExtentScrollController(initialItem: songPlayingTime);
    songTitleController.text = songTitle;
    return ChangeNotifierProvider<GroupSongEditModel>(
      create: (_) => GroupSongEditModel()
        ..init(
          groupID: groupID,
          songID: songID,
          songTitle: songTitle,
          songPlayingTime: songPlayingTime,
        ),
      child: Consumer<GroupSongEditModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('曲を編集'),
            actions: [
              FlatButton(
                child: Text(
                  '保存',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () async {
                  model.startLoading();
                  try {
                    await model.editSong();
                    await _showTextDialog(context, '変更しました');
                    Navigator.pop(context);
                  } catch (e) {
                    _showTextDialog(context, e.toString());
                  }
                  model.endLoading();
                },
              ),
            ],
          ),
          body: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: Colors.grey[800],
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: songTitleController,
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            hintText: 'タイトル',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 16.0),
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
                        Divider(height: 0.5),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '演奏時間',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 24.0),
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
                                      .map((value) => Text(
                                            '$value',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                '分',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: double.infinity,
                    color: Colors.redAccent,
                    child: FlatButton(
                      child: Text(
                        '削除',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        bool isDelete =
                            await _confirmDeleteDialog(context, '削除しますか？');
                        if (isDelete) {
                          model.startLoading();
                          try {
                            await model.deleteSong();
                            await _showTextDialog(context, '削除しました');
                            Navigator.pop(context);
                          } catch (e) {
                            _showTextDialog(context, e.toString());
                          }
                          model.endLoading();
                        }
                      },
                    ),
                  ),
                ],
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
