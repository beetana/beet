import 'package:beet/constants.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final model;

  CalendarWidget({Key key, this.model}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      startDay: DateTime(1980, 1, 1),
      endDay: DateTime(2050, 12, 31),
      locale: 'ja_JP',
      calendarController: _calendarController,
      availableCalendarFormats: {CalendarFormat.month: ''},
      events: widget.model.events,
      holidays: widget.model.holidays,
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
                  widget.model.holidays[date][0],
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
        widget.model.selectedDay =
            DateTime(date.year, date.month, date.day, 12);
        widget.model.getSelectedEvents();
      },
      onVisibleDaysChanged:
          (DateTime first, DateTime last, CalendarFormat format) async {
        widget.model.first = first;
        widget.model.last = last;
        try {
          await widget.model.getEvents();
          widget.model.fetchHolidays();
          widget.model.getSelectedEvents();
        } catch (e) {
          showMessageDialog(context, e.toString());
        }
      },
      onCalendarCreated:
          (DateTime first, DateTime last, CalendarFormat format) async {
        widget.model.first = first;
        widget.model.last = last;
        try {
          await widget.model.getEvents();
          widget.model.fetchHolidays();
          widget.model.getSelectedEvents();
        } catch (e) {
          showMessageDialog(context, e.toString());
        }
      },
    );
  }
}
