import 'package:beet/event.dart';
import 'package:beet/models/user_models/user_calendar_model.dart';
import 'package:beet/screens/user_screens/user_add_event_screen.dart';
import 'package:beet/screens/user_screens/user_event_screen.dart';
import 'package:beet/widgets/event_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:beet/widgets/add_floating_action_button.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class UserCalendarScreen extends StatelessWidget {
  UserCalendarScreen({this.userID});
  final String userID;
  final _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserCalendarModel>(
      create: (_) => UserCalendarModel()..init(),
      child: Consumer<UserCalendarModel>(builder: (context, model, child) {
        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                //TODO 祝日を選択した際に何の日なのか画面に表示したい
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
                    weekdayStyle: TextStyle(color: Colors.black),
                    weekendStyle: TextStyle(color: Colors.black54),
                  ),
                  calendarStyle: CalendarStyle(
                    weekendStyle: TextStyle(color: Colors.black54),
                    selectedColor: Colors.cyan[400],
                    todayColor: Colors.cyan[200],
                    markersColor: Colors.brown[700],
                    outsideDaysVisible: false,
                  ),
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonVisible: false,
                  ),
                  onDaySelected: (DateTime day, List events) {
                    model.selectedDay =
                        DateTime(day.year, day.month, day.day, 12);
                    model.getSelectedEvents();
                  },
                  onVisibleDaysChanged: (DateTime first, DateTime last,
                      CalendarFormat format) async {
                    await model.getEvents(
                      userID: userID,
                      first: first,
                      last: last,
                    );
                    model.getHolidays(first: first);
                    model.getSelectedEvents();
                  },
                  onCalendarCreated: (DateTime first, DateTime last,
                      CalendarFormat format) async {
                    await model.getEvents(
                      userID: userID,
                      first: first,
                      last: last,
                    );
                    model.getHolidays(first: first);
                    model.getSelectedEvents();
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemExtent: 80.0,
                        itemCount: model.selectedEvents.length,
                        itemBuilder: (context, index) {
                          Event event = model.selectedEvents[index];
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
                                  builder: (context) => UserEventScreen(
                                    userID: userID,
                                    event: event,
                                  ),
                                ),
                              );
                              await model.getEvents(
                                userID: userID,
                                first: _calendarController.visibleDays[0],
                                last: _calendarController.visibleDays.last,
                              );
                              model.getSelectedEvents();
                            },
                          );
                        }),
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
                      await model.getEvents(
                        userID: userID,
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
