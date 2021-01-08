import 'package:beet/models/group_models/group_add_song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupAddSongScreen extends StatelessWidget {
  GroupAddSongScreen({this.groupID});
  final String groupID;
  final songTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupAddSongModel>(
      create: (_) => GroupAddSongModel(),
      child: Consumer<GroupAddSongModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('曲を追加'),
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
                    await model.addSong(groupID);
                    await _showTextDialog(context, '追加しました');
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
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: songTitleController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'タイトル',
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
                              itemExtent: 32.0,
                              magnification: 1.2,
                              useMagnifier: true,
                              onSelectedItemChanged: (index) {
                                model.songPlayingTime =
                                    model.songPlayingTimes[index];
                              },
                              children: model.songPlayingTimes
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
