import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_add_song_model.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupAddSongScreen extends StatelessWidget {
  GroupAddSongScreen({this.groupID});
  final String groupID;
  final songTitleController = TextEditingController();
  final songMemoController = TextEditingController();
  final scrollController = ScrollController();

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
                Scrollbar(
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
                            ),
                            onChanged: (text) {
                              model.songTitle = text;
                            },
                          ),
                          BasicDivider(),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
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
                                onTap: () async {
                                  await Future.delayed(
                                    Duration(milliseconds: 100),
                                  );
                                  scrollController.jumpTo(scrollController
                                      .position.maxScrollExtent);
                                },
                                controller: songMemoController,
                                maxLines: 7,
                                decoration: InputDecoration(
                                  hintText: 'メモ',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0,
                                    horizontal: 4.0,
                                  ),
                                ),
                                onChanged: (text) {
                                  model.songMemo = text;
                                },
                              ),
                            ),
                          ),
                          BasicDivider(),
                          SizedBox(
                            height: 16.0,
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
