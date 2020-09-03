import 'package:beet/event.dart';
import 'package:beet/models/group_models/group_event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupEventScreen extends StatelessWidget {
  GroupEventScreen({this.groupID, this.event});
  final String groupID;
  final Event event;
  final dateFormat = DateFormat('y/M/d(E)  H:mm', 'ja_JP');
  final eventTitleController = TextEditingController();
  final eventPlaceController = TextEditingController();
  final eventMemoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupEventModel>(
      create: (_) => GroupEventModel()..init(event),
      child: Consumer<GroupEventModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('イベント詳細'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  '編集',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {},
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(event.eventTitle),
                Visibility(
                  visible: event.eventPlace.isNotEmpty,
                  child: Text('@${event.eventPlace}'),
                ),
                model.eventDateWidget(),
                Divider(height: 0.5),
                Text(event.eventMemo),
              ],
            ),
          ),
        );
      }),
    );
  }
}
