import 'package:beet/models/group_models/group_set_list_model_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupSetListScreen2 extends StatelessWidget {
  GroupSetListScreen2({this.setList});
  final List<String> setList;
  final eventDateFormat = DateFormat('y/M/d(E)', 'ja_JP');
  final eventTitleController = TextEditingController();
  final eventPlaceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSetListModel2>(
      create: (_) => GroupSetListModel2()..init(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('詳細'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '追加',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Consumer<GroupSetListModel2>(builder: (context, model, child) {
          return Padding(
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
          );
        }),
      ),
    );
  }
}
