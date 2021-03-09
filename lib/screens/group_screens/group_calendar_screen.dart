import 'package:beet/screens/group_screens/group_add_event_screen.dart';
import 'package:beet/screens/group_screens/group_event_details_screen.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/event_list_tile.dart';
import 'package:beet/widgets/group_calendar.dart';
import 'package:flutter/material.dart';
import 'package:beet/models/group_models/group_calendar_model.dart';
import 'package:beet/widgets/add_floating_action_button.dart';
import 'package:provider/provider.dart';

class GroupCalendarScreen extends StatelessWidget {
  GroupCalendarScreen({this.groupID});
  final String groupID;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupCalendarModel>(
      create: (_) => GroupCalendarModel()..init(groupID: groupID),
      child: Consumer<GroupCalendarModel>(builder: (context, model, child) {
        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                GroupCalendar(model: model),
                BasicDivider(),
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemExtent: 64.0,
                      itemCount: model.selectedEvents.length + 1,
                      itemBuilder: (context, index) {
                        if (index < model.selectedEvents.length) {
                          final event = model.selectedEvents[index];
                          return EventListTile(
                            eventTitle: event.eventTitle,
                            eventPlace: event.eventPlace,
                            isAllDay: event.isAllDay,
                            startingDateTime: event.startingDateTime,
                            endingDateTime: event.endingDateTime,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupEventDetailsScreen(
                                    groupID: groupID,
                                    event: event,
                                  ),
                                ),
                              );
                              await model.getEvents();
                              model.getSelectedEvents();
                            },
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  AddFloatingActionButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupAddEventScreen(
                            groupID: groupID,
                            dateTime: model.selectedDay,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                      await model.getEvents();
                      model.getSelectedEvents();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
