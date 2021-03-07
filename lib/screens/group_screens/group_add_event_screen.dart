import 'package:beet/models/group_models/group_add_event_model.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupAddEventScreen extends StatelessWidget {
  GroupAddEventScreen({this.groupID, this.dateTime});
  final groupID;
  final dateTime;
  final dateFormat = DateFormat('y/M/d(E)    H:mm', 'ja_jp');
  final eventTitleController = TextEditingController();
  final eventPlaceController = TextEditingController();
  final eventMemoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupAddEventModel>(
      create: (_) => GroupAddEventModel()..init(dateTime: dateTime),
      child: Consumer<GroupAddEventModel>(builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            FocusScope.of(context).unfocus();
            await Future.delayed(Duration(milliseconds: 80));
            return true;
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                Scaffold(
                  appBar: AppBar(
                    title: Text('イベントを追加'),
                    centerTitle: true,
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          '追加',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () async {
                          model.startLoading();
                          try {
                            await model.addEvent(groupID: groupID);
                            Navigator.pop(context);
                          } catch (e) {
                            _showTextDialog(context, e.toString());
                          }
                          model.endLoading();
                        },
                      ),
                    ],
                  ),
                  body: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: eventTitleController,
                            decoration: InputDecoration(
                              hintText: 'タイトル',
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              if (model.isShowStartingPicker == true) {
                                model.showStartingDateTimePicker();
                              }
                              if (model.isShowEndingPicker == true) {
                                model.showEndingDateTimePicker();
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
                              hintText: '場所',
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              if (model.isShowStartingPicker == true) {
                                model.showStartingDateTimePicker();
                              }
                              if (model.isShowEndingPicker == true) {
                                model.showEndingDateTimePicker();
                              }
                            },
                            onChanged: (text) {
                              model.eventPlace = text;
                            },
                          ),
                          BasicDivider(),
                          SizedBox(
                            height: 16.0,
                          ),
                          SwitchListTile(
                            value: model.isAllDay,
                            title: Text('終日'),
                            onChanged: (value) {
                              model.switchIsAllDay(value);
                            },
                          ),
                          BasicDivider(),
                          ListTile(
                            title: Text('開始'),
                            trailing: Text(model.tileDateFormat
                                .format(model.startingDateTime)),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              model.showStartingDateTimePicker();
                            },
                          ),
                          model.startingDateTimePickerBox,
                          BasicDivider(),
                          ListTile(
                            title: Text('終了'),
                            trailing: Text(model.tileDateFormat
                                .format(model.endingDateTime)),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              model.showEndingDateTimePicker();
                            },
                          ),
                          model.endingDateTimePickerBox,
                          Scrollbar(
                            child: TextField(
                              controller: eventMemoController,
                              maxLines: 10,
                              decoration: InputDecoration(
                                hintText: 'メモ',
                                border: InputBorder.none,
                              ),
                              onTap: () {
                                if (model.isShowStartingPicker == true) {
                                  model.showStartingDateTimePicker();
                                }
                                if (model.isShowEndingPicker == true) {
                                  model.showEndingDateTimePicker();
                                }
                              },
                              onChanged: (text) {
                                model.eventMemo = text;
                              },
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
