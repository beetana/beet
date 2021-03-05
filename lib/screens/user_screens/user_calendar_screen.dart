import 'package:beet/models/user_models/user_calendar_model.dart';
import 'package:beet/screens/user_screens/user_add_event_screen.dart';
import 'package:beet/screens/user_screens/user_event_details_screen.dart';
import 'package:beet/widgets/user_calendar.dart';
import 'package:beet/widgets/event_list_tile.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:beet/widgets/add_floating_action_button.dart';
import 'package:provider/provider.dart';

class UserCalendarScreen extends StatelessWidget {
  UserCalendarScreen({this.userID});
  final String userID;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserCalendarModel>(
      create: (_) => UserCalendarModel()..init(userID: userID),
      child: Consumer<UserCalendarModel>(builder: (context, model, child) {
        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                UserCalendar(model: model),
                ThinDivider(),
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemExtent: 96.0,
                      itemCount: model.selectedEvents.length + 1,
                      itemBuilder: (context, index) {
                        if (index < model.selectedEvents.length) {
                          final event = model.selectedEvents[index];
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
                                  builder: (context) => UserEventDetailsScreen(
                                    userID: userID,
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
                          builder: (context) => UserAddEventScreen(
                            userID: userID,
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
