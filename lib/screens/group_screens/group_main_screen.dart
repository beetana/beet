import 'package:beet/models/group_models/group_main_model.dart';
import 'package:beet/screens/group_screens/group_event_screen.dart';
import 'package:beet/widgets/group_event_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupMainScreen extends StatelessWidget {
  GroupMainScreen({this.groupID});
  final String groupID;
  final dateFormat = DateFormat('y/M/d(E)', 'ja_JP');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupMainModel>(
      create: (_) => GroupMainModel()..getEventList(groupID),
      child: Consumer<GroupMainModel>(builder: (context, model, child) {
        if (model.eventList.isNotEmpty) {
          return Column(
            children: <Widget>[
              SizedBox(height: 8.0),
              Text(
                dateFormat.format(model.currentDateTime),
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 8.0),
              Divider(
                thickness: 0.1,
                height: 0.1,
                color: Colors.grey[800],
              ),
              Expanded(
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemExtent: 96.0,
                  itemCount: model.eventList.length,
                  itemBuilder: (context, index) {
                    final event = model.eventList[index];
                    return GroupEventListTile(
                      eventTitle: event.eventTitle,
                      eventPlace: event.eventPlace,
                      isAllDay: event.isAllDay,
                      startingDateTime: event.startingDateTime,
                      endingDateTime: event.endingDateTime,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupEventScreen(
                              groupID: groupID,
                              event: event,
                            ),
                          ),
                        );
                        await model.getEventList(groupID);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } else if (model.isLoading == true) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text('予定されているイベントはありません'),
          );
        }
      }),
    );
  }
}
