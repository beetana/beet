import 'package:beet/models/group_models/group_set_list_model_3.dart';
import 'package:beet/screens/group_screens/group_screen.dart';
import 'package:beet/widgets/set_list_tile.dart';
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
          body: Stack(
            children: <Widget>[
              SafeArea(
                child: SingleChildScrollView(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            eventTitle,
                                            style: TextStyle(fontSize: 17.0),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            eventDateText,
                                            style: TextStyle(fontSize: 13.0),
                                          ),
                                          eventPlace.isNotEmpty
                                              ? Text(
                                                  ' @$eventPlace',
                                                  style:
                                                      TextStyle(fontSize: 13.0),
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
                      SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Divider(
                    thickness: 0.1,
                    height: 0.1,
                    color: Colors.grey[800],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 40.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('$songNum 曲'),
                              Text('$totalPlayTime 分'),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 40.0,
                        child: VerticalDivider(
                          thickness: 0.2,
                          width: 0.2,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 40.0,
                          child: FlatButton(
                            child: Text(
                              '戻る',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 17.0,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 40.0,
                        child: VerticalDivider(
                          thickness: 0.2,
                          width: 0.2,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 40.0,
                          child: FlatButton(
                            child: Text(
                              '保存',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 17.0,
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
