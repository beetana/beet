import 'package:beet/models/group_models/group_main_model.dart';
import 'package:beet/widgets/event_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupMainScreen extends StatelessWidget {
  GroupMainScreen({this.groupID});
  final String groupID;
  final dateFormat = DateFormat("y/M/d");
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupMainModel>(
      create: (_) => GroupMainModel()..getEventList(groupID),
      child: Consumer<GroupMainModel>(builder: (context, model, child) {
        return Padding(
          padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: Column(
            children: <Widget>[
              Text(
                dateFormat.format(DateTime.now()),
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 10.0),
              Flexible(
                child: ListView.builder(
                    physics: ScrollPhysics(),
                    itemExtent: 70.0,
                    itemCount: model.eventList.length,
                    itemBuilder: (context, index) {
                      final event = model.eventList[index];
                      return EventListTile(
                        eventTitle: event.eventTitle,
                        eventPlace: event.eventPlace,
                        eventMemo: event.eventMemo,
                        startingDateTime: event.startingDateTime,
                        endingDateTime: event.endingDateTime,
                      );
                    }),
              ),
            ],
          ),
        );
      }),
    );
  }
}
