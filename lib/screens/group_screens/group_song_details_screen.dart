import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_song_details_model.dart';
import 'package:beet/screens/group_screens/group_edit_song_screen.dart';
import 'package:beet/song.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSongDetailsScreen extends StatelessWidget {
  GroupSongDetailsScreen({this.groupID, this.song});
  final String groupID;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSongDetailsModel>(
      create: (_) =>
          GroupSongDetailsModel()..init(groupID: groupID, song: song),
      child: Consumer<GroupSongDetailsModel>(builder: (context, model, child) {
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
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 16.0),
                          Text(
                            'タイトル',
                            style: TextStyle(
                              color: kSlightlyTransparentPrimaryColor,
                            ),
                          ),
                          Text(
                            model.songTitle,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            '演奏時間',
                            style: TextStyle(
                              color: kSlightlyTransparentPrimaryColor,
                            ),
                          ),
                          Text(
                            '${model.songPlayingTime.toString()}分',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'メモ',
                            style: TextStyle(
                              color: kSlightlyTransparentPrimaryColor,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          BasicDivider(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: SingleChildScrollView(
                            child: Text(model.songMemo),
                          ),
                        ),
                      ),
                    ),
                    BasicDivider(
                      indent: 16.0,
                      endIndent: 16.0,
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    Center(
                      child: FlatButton(
                        child: Text(
                          '削除',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                        onPressed: () async {
                          bool isDelete = await _confirmDeleteDialog(
                              context, 'この曲を削除しますか？');
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
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'キャンセル',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text(
              '削除',
              style: kDeleteButtonTextStyle,
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
