import 'package:beet/screens/group_screens/group_add_event_screen.dart';
import 'package:beet/screens/group_screens/group_event_details_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/event_list_tile.dart';
import 'package:beet/widgets/group_calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:beet/models/group_models/group_calendar_model.dart';
import 'package:beet/widgets/add_floating_action_button.dart';
import 'package:provider/provider.dart';

class GroupCalendarScreen extends StatelessWidget {
  final String groupId;
  final double textScale;

  GroupCalendarScreen({required this.groupId, required this.textScale});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupCalendarModel>(
      create: (_) => GroupCalendarModel()..init(groupId: groupId),
      child: Consumer<GroupCalendarModel>(builder: (context, model, child) {
        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                GroupCalendarWidget(model: model),
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
                        itemExtent: 64.0 * textScale,
                        // ListTileとFABが被らないよう一つ余分にitemを作ってSizedBoxを返す
                        itemCount: model.selectedEvents.length + 1,
                        itemBuilder: (context, index) {
                          if (index < model.selectedEvents.length) {
                            final event = model.selectedEvents[index];
                            return EventListTile(
                              event: event,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GroupEventDetailsScreen(
                                      groupId: groupId,
                                      event: event,
                                    ),
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
                    builder: (context) => GroupAddEventScreen(
                      groupId: groupId,
                      dateTime: model.selectedDay,
                    ),
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
