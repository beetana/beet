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
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('曲を追加'),
              centerTitle: true,
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
                  padding:
                      EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
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
                            autofocus: true,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              hintText: 'タイトル',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 16.0),
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
