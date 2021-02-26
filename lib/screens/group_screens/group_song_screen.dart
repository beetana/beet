import 'package:beet/models/group_models/group_song_model.dart';
import 'package:beet/screens/group_screens/group_edit_song_screen.dart';
import 'package:beet/song.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSongScreen extends StatelessWidget {
  GroupSongScreen({this.groupID, this.song});
  final String groupID;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSongModel>(
      create: (_) => GroupSongModel()..init(groupID: groupID, song: song),
      child: Consumer<GroupSongModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('曲詳細'),
            centerTitle: true,
            actions: <Widget>[
              FlatButton(
                child: Text(
                  '編集',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupEditSongScreen(
                        groupID: groupID,
                        song: model.song,
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                  model.startLoading();
                  try {
                    await model.getSong();
                  } catch (e) {
                    _showTextDialog(context, e.toString());
                  }
                  model.endLoading();
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      Text(
                        'タイトル：',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        model.songTitle,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        '演奏時間：',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        '${model.songPlayingTime.toString()}分',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 56.0),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                            await _confirmDeleteDialog(context, 'この曲を削除しますか？');
                        if (isDelete == true) {
                          model.startLoading();
                          try {
                            await model.deleteSong();
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
            Radius.circular(10.0),
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
            Radius.circular(10.0),
          ),
        ),
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'キャンセル',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text(
              '削除',
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
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
