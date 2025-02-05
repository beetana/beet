import 'package:beet/models/user_models/user_calendar_model.dart';
import 'package:beet/objects/event.dart';
import 'package:beet/screens/user_screens/user_add_event_screen.dart';
import 'package:beet/screens/user_screens/user_event_details_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/add_floating_action_button.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/event_list_tile.dart';
import 'package:beet/widgets/user_calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserCalendarScreen extends StatelessWidget {
  final double textScale;

  UserCalendarScreen({required this.textScale});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserCalendarModel>(
      create: (_) => UserCalendarModel()..init(),
      child: Consumer<UserCalendarModel>(builder: (context, model, child) {
        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                UserCalendarWidget(model: model),
                BasicDivider(),
                Expanded(
                  child: Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        try {
                          await model.fetchEvents();
                          model.showEventsOfDay();
                        } catch (e) {
                          showMessageDialog(context, e.toString());
                        }
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemExtent: 96.0 * textScale,
                        // ListTileとFABが被らないよう一つ余分にitemを作ってSizedBoxを返す
                        itemCount: model.selectedEvents.length + 1,
                        itemBuilder: (context, index) {
                          if (index < model.selectedEvents.length) {
                            final Event event = model.selectedEvents[index];
                            final bool isOwn = event.ownerId == model.userId;
                            return EventListTile(
                              event: event,
                              imageURL: model.eventPlanner[event.ownerId]!.imageURL,
                              name: model.eventPlanner[event.ownerId]!.name,
                              isOwn: isOwn,
                              textScale: textScale,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserEventDetailsScreen(event: event),
                                  ),
                                );
                                try {
                                  await model.fetchEvents();
                                  model.showEventsOfDay();
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
                    builder: (context) => UserAddEventScreen(dateTime: model.selectedDay),
                    fullscreenDialog: true,
                  ),
                );
                try {
                  await model.fetchEvents();
                  model.showEventsOfDay();
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
