import 'package:beet/utilities/constants.dart';
import 'package:beet/models/group_models/group_set_list_model_2.dart';
import 'package:beet/screens/group_screens/group_set_list_screen_3.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSetListScreen2 extends StatelessWidget {
  GroupSetListScreen2({
    this.setList,
    this.songNum,
    this.totalPlayTime,
    this.groupId,
  });
  final List<String> setList;
  final int songNum;
  final int totalPlayTime;
  final String groupId;
  final eventTitleController = TextEditingController();
  final eventPlaceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSetListModel2>(
      create: (_) => GroupSetListModel2()..init(),
      child: Consumer<GroupSetListModel2>(builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            if (model.isShowEventDatePicker == true) {
              model.showEventDatePicker();
            }
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('詳細'),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: eventTitleController,
                            decoration: InputDecoration(
                              hintText: 'イベントタイトル',
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              if (model.isShowEventDatePicker == true) {
                                model.showEventDatePicker();
                              }
                            },
                            onChanged: (text) {
                              model.eventTitle = text;
                            },
                          ),
                          BasicDivider(),
                          TextField(
                            controller: eventPlaceController,
                            decoration: InputDecoration(
                              hintText: '会場',
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              if (model.isShowEventDatePicker == true) {
                                model.showEventDatePicker();
                              }
                            },
                            onChanged: (text) {
                              model.eventPlace = text;
                            },
                          ),
                          BasicDivider(),
                          ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 0.0),
                            title: Text(
                              '日付',
                              style: TextStyle(
                                color: kSlightlyTransparentPrimaryColor,
                              ),
                            ),
                            trailing: Text(model.eventDateText),
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              // AndroidでDatePickerを開く際にUIが崩れることがあるので少し待つ
                              // 他にいい方法があるはず
                              await Future.delayed(
                                Duration(milliseconds: 80),
                              );
                              model.showEventDatePicker();
                            },
                          ),
                          model.eventDatePickerBox,
                          BasicDivider(),
                        ],
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text('$songNum 曲'),
                            Text('$totalPlayTime 分'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: TextButton(
                            child: Text(
                              '決定',
                              style: TextStyle(
                                color: kEnterButtonColor,
                                fontSize: 16.0,
                              ),
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
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
                                    groupId: groupId,
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
            ),
          ),
        );
      }),
    );
  }
}
