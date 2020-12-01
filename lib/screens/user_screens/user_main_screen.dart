import 'package:beet/models/user_models/user_main_model.dart';
import 'package:beet/screens/user_screens/user_event_screen.dart';
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
      create: (_) => UserMainModel()..getEventList(userID),
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
                      physics: AlwaysScrollableScrollPhysics(),
                      itemExtent: 120.0,
                      itemCount: model.eventList.length,
                      itemBuilder: (context, index) {
                        final event = model.eventList[index];
                        return EventListTile(
                          imageURL: model.eventPlanner[event.myID].imageURL,
                          name: model.eventPlanner[event.myID].name,
                          eventTitle: event.eventTitle,
                          eventPlace: event.eventPlace,
                          isAllDay: event.isAllDay,
                          startingDateTime: event.startingDateTime,
                          endingDateTime: event.endingDateTime,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserEventScreen(
                                  userID: userID,
                                  event: event,
                                ),
                              ),
                            );
                            await model.getEventList(userID);
                          },
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
