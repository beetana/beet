import 'package:beet/models/user_models/user_main_model.dart';
import 'package:beet/widgets/event_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserMainScreen extends StatelessWidget {
  UserMainScreen({this.userID});
  final String userID;
  final dateFormat = DateFormat('y/M/d(E)', 'ja_JP');
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserMainModel>(
      create: (_) => UserMainModel(),
      child: Consumer<UserMainModel>(builder: (context, model, child) {
        if (model.eventList.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Column(
              children: <Widget>[
                Text(
                  dateFormat.format(model.currentDateTime),
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(height: 10.0),
                Expanded(
                  child: ListView.builder(
                      physics: ScrollPhysics(),
                      itemExtent: 80.0,
                      itemCount: model.eventList.length,
                      itemBuilder: (context, index) {
                        final event = model.eventList[index];
                        return EventListTile(
                          eventID: event.eventID,
                          eventTitle: event.eventTitle,
                          eventPlace: event.eventPlace,
                          eventMemo: event.eventMemo,
                          isAllDay: event.isAllDay,
                          startingDateTime: event.startingDateTime,
                          endingDateTime: event.endingDateTime,
                          onTap: () {},
                        );
                      }),
                ),
              ],
            ),
          );
        } else if (model.isLoading == true) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text('イベントがありません'),
          );
        }
      }),
    );
  }
}
