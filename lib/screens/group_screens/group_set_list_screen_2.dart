import 'package:beet/models/group_models/group_set_list_model_2.dart';
import 'package:beet/screens/group_screens/group_set_list_screen_3.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSetListScreen2 extends StatelessWidget {
  GroupSetListScreen2({
    this.setList,
    this.songNum,
    this.totalPlayTime,
    this.groupID,
  });
  final List<String> setList;
  final int songNum;
  final int totalPlayTime;
  final String groupID;
  final eventTitleController = TextEditingController();
  final eventPlaceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSetListModel2>(
      create: (_) => GroupSetListModel2()..init(),
      child: Consumer<GroupSetListModel2>(builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('詳細'),
              centerTitle: true,
            ),
            body: Stack(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: eventTitleController,
                          decoration: InputDecoration(hintText: 'イベントタイトル'),
                          onTap: () {
                            if (model.isShowEventDatePicker == true) {
                              model.showEventDatePicker();
                            }
                          },
                          onChanged: (text) {
                            model.eventTitle = text;
                          },
                        ),
                        TextField(
                          controller: eventPlaceController,
                          decoration: InputDecoration(hintText: '会場'),
                          onTap: () {
                            if (model.isShowEventDatePicker == true) {
                              model.showEventDatePicker();
                            }
                          },
                          onChanged: (text) {
                            model.eventPlace = text;
                          },
                        ),
                        ListTile(
                          title: Text('日付'),
                          trailing: Text(model.eventDateText),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            model.showEventDatePicker();
                          },
                        ),
                        model.eventDatePickerBox,
                        BasicDivider(),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    BasicDivider(),
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
                            thickness: 1.0,
                            width: 1.0,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 40.0,
                            child: FlatButton(
                              child: Text(
                                '決定',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 17.0,
                                ),
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
                                      groupID: groupID,
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
            ),
          ),
        );
      }),
    );
  }
}
