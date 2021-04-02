import 'package:beet/models/user_models/user_calendar_model.dart';
import 'package:beet/screens/user_screens/user_add_event_screen.dart';
import 'package:beet/screens/user_screens/user_event_details_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/calendar_widget.dart';
import 'package:beet/widgets/event_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:beet/widgets/add_floating_action_button.dart';
import 'package:provider/provider.dart';

class UserCalendarScreen extends StatelessWidget {
  final String userId;
  final double textScale;

  UserCalendarScreen({this.userId, this.textScale});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserCalendarModel>(
      create: (_) => UserCalendarModel()..init(userId: userId),
      child: Consumer<UserCalendarModel>(builder: (context, model, child) {
        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                CalendarWidget(model: model),
                BasicDivider(),
                Expanded(
                  child: Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        try {
                          await model.getEvents();
                          model.getSelectedEvents();
                        } catch (e) {
                          showMessageDialog(context, e.toString());
                        }
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemExtent: 96.0 * textScale,
                        itemCount: model.selectedEvents.length + 1,
                        itemBuilder: (context, index) {
                          if (index < model.selectedEvents.length) {
                            final event = model.selectedEvents[index];
                            return EventListTile(
                              event: event,
                              imageURL:
                                  model.eventPlanner[event.ownerId].imageURL,
                              name: model.eventPlanner[event.ownerId].name,
                              textScale: textScale,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserEventDetailsScreen(
                                      userId: userId,
                                      event: event,
                                    ),
                                  ),
                                );
                                try {
                                  await model.getEvents();
                                  model.getSelectedEvents();
                                } catch (e) {
                                  showMessageDialog(context, e.toString());
                                }
                              },
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            AddFloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserAddEventScreen(
                      userId: userId,
                      dateTime: model.selectedDay,
                    ),
                    fullscreenDialog: true,
                  ),
                );
                try {
                  await model.getEvents();
                  model.getSelectedEvents();
                } catch (e) {
                  showMessageDialog(context, e.toString());
                }
              },
            ),
          ],
        );
      }),
    );
  }
}
