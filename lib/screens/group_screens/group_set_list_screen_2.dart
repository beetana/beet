import 'package:beet/models/group_models/group_set_list_model_2.dart';
import 'package:beet/screens/group_screens/group_set_list_screen_3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSetListScreen2 extends StatelessWidget {
  GroupSetListScreen2({this.setList, this.songNum, this.totalPlayTime});
  final List<String> setList;
  final int songNum;
  final int totalPlayTime;
  final eventTitleController = TextEditingController();
  final eventPlaceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSetListModel2>(
      create: (_) => GroupSetListModel2()..init(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('詳細'),
        ),
        body: Consumer<GroupSetListModel2>(builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: eventTitleController,
                      decoration: InputDecoration(hintText: 'タイトル'),
                      onChanged: (text) {
                        model.eventTitle = text;
                      },
                    ),
                    TextField(
                      controller: eventPlaceController,
                      decoration: InputDecoration(hintText: '場所'),
                      onChanged: (text) {
                        model.eventPlace = text;
                      },
                    ),
                    ListTile(
                      title: Text('日付'),
                      trailing: Text(model.eventDateText),
                      onTap: () {
                        model.showEventDatePicker();
                      },
                    ),
                    model.eventDatePickerBox,
                    Divider(height: 0.5),
                  ],
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
                              '日付未定',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              model.dateUndecided();
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
                              '決定',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupSetListScreen3(
                                    setList: setList,
                                    eventTitle: model.eventTitle,
                                    eventPlace: model.eventPlace,
                                    eventDateText: model.eventDateText,
                                    songNum: songNum,
                                    totalPlayTime: totalPlayTime,
                                  ),
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
          );
        }),
      ),
    );
  }
}
