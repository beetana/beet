import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_set_list_model_3.dart';
import 'package:beet/screens/group_screens/group_screen.dart';
import 'package:beet/widgets/set_list_tile.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSetListScreen3 extends StatelessWidget {
  GroupSetListScreen3({
    this.setList,
    this.eventTitle,
    this.eventPlace,
    this.eventDateText,
    this.songNum,
    this.totalPlayTime,
    this.groupID,
  });
  final List<String> setList;
  final String eventTitle;
  final String eventPlace;
  final String eventDateText;
  final int songNum;
  final int totalPlayTime;
  final String groupID;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSetListModel3>(
      create: (_) => GroupSetListModel3(),
      child: Consumer<GroupSetListModel3>(builder: (context, model, child) {
        return Scaffold(
          backgroundColor: kDullWhiteColor,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.0 / 1.415,
                  child: RepaintBoundary(
                    key: model.globalKey,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 16.0, right: 16.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      eventTitle,
                                      style: TextStyle(fontSize: 17.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      eventDateText,
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                    eventPlace.isNotEmpty
                                        ? Text(
                                            ' @$eventPlace',
                                            style: TextStyle(fontSize: 13.0),
                                          )
                                        : Text(''),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: setList.length,
                              itemExtent: 30.5,
                              itemBuilder: (context, index) {
                                return SetListTile(
                                  setList: setList,
                                  index: index,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                ),
                ThinDivider(),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('$songNum 曲'),
                          Text('$totalPlayTime 分'),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: FlatButton(
                          child: Text(
                            '戻る',
                            style: TextStyle(
                              color: kSlightlyTransparentPrimaryColor,
                              fontSize: 16.0,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: FlatButton(
                          child: Text(
                            '保存',
                            style: TextStyle(
                              color: kEnterButtonColor,
                              fontSize: 16.0,
                            ),
                          ),
                          onPressed: () async {
                            await model.saveSetListImage();
                            await _showTextDialog(context, '画像を保存しました');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    GroupScreen(groupID: groupID),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
        actions: [
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
