import 'package:beet/constants.dart';
import 'package:beet/screens/group_screens/group_add_event_screen.dart';
import 'package:beet/screens/group_screens/group_event_details_screen.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/event_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:beet/models/group_models/group_calendar_model.dart';
import 'package:beet/widgets/add_floating_action_button.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class GroupCalendarScreen extends StatelessWidget {
  GroupCalendarScreen({this.groupID});
  final String groupID;
  final _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupCalendarModel>(
      create: (_) => GroupCalendarModel()..init(),
      child: Consumer<GroupCalendarModel>(builder: (context, model, child) {
        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                TableCalendar(
                  startDay: DateTime(1980, 1, 1),
                  endDay: DateTime(2050, 12, 31),
                  locale: 'ja_JP',
                  calendarController: _calendarController,
                  availableCalendarFormats: {CalendarFormat.month: ''},
                  events: model.events,
                  holidays: model.holidays,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: Colors.deepOrange[300]),
                  ),
                  calendarStyle: CalendarStyle(
                    weekendStyle: TextStyle(color: Colors.deepOrange[400]),
                    holidayStyle: TextStyle(color: Colors.deepOrange[400]),
                    selectedColor: kSlightlyTransparentPrimaryColor,
                    todayColor: kTransparentPrimaryColor,
                    outsideDaysVisible: false,
                  ),
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                      fontSize: 18.0,
                      color: kPrimaryColor,
                    ),
                  ),
                  builders: CalendarBuilders(
                    markersBuilder: (context, date, events, holidays) {
                      List<Widget> children = [];
                      if (events.isNotEmpty) {
                        children.add(
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Icon(
                              Icons.event_available,
                              size: 15.0,
                              color: kPrimaryColor,
                            ),
                          ),
                        );
                      }
                      if (holidays.isNotEmpty) {
                        children.add(
                          Positioned(
                            bottom: 2.0,
                            child: Text(
                              model.holidays[date][0],
                              style: TextStyle(
                                fontSize: 8.0,
                              ),
                            ),
                          ),
                        );
                      }
                      return children;
                    },
                  ),
                  onDaySelected: (DateTime date, List events, List holidays) {
                    model.selectedDay =
                        DateTime(date.year, date.month, date.day, 12);
                    model.getSelectedEvents();
                  },
                  onVisibleDaysChanged: (DateTime first, DateTime last,
                      CalendarFormat format) async {
                    await model.getEvents(
                      groupID: groupID,
                      first: first,
                      last: last,
                    );
                    model.fetchHolidays(first: first);
                    model.getSelectedEvents();
                  },
                  onCalendarCreated: (DateTime first, DateTime last,
                      CalendarFormat format) async {
                    await model.getEvents(
                      groupID: groupID,
                      first: first,
                      last: last,
                    );
                    model.fetchHolidays(first: first);
                    model.getSelectedEvents();
                  },
                ),
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
                              await model.getEvents(
                                groupID: groupID,
                                first: _calendarController.visibleDays[0],
                                last: _calendarController.visibleDays.last,
                              );
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
                      await model.getEvents(
                        groupID: groupID,
                        first: _calendarController.visibleDays[0],
                        last: _calendarController.visibleDays.last,
                      );
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
