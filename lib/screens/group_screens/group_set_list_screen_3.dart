import 'package:beet/models/group_models/group_set_list_model_3.dart';
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
  });
  final List<String> setList;
  final String eventTitle;
  final String eventPlace;
  final String eventDateText;
  final int songNum;
  final int totalPlayTime;
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSetListModel3>(
      create: (_) => GroupSetListModel3(),
      child: Consumer<GroupSetListModel3>(builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              SafeArea(
                child: AspectRatio(
                  aspectRatio: 1.0 / 1.415,
                  child: Container(
                    color: Colors.black12,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                eventTitle,
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                eventDateText,
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Text(
                                ' @$eventPlace',
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: setList.length,
                              itemExtent: 30.5,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    '${index + 1}. ${setList[index]}',
                                    style: TextStyle(fontSize: 22.0),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                '$songNum 曲',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '$totalPlayTime 分',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          height: 40.0,
                          child: FlatButton(
                            child: Text(
                              '戻る',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.cyan,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                            ),
                          ),
                          height: 40.0,
                          child: FlatButton(
                            child: Text(
                              '保存',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {},
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
