import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_calendar_model.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class GroupCalendarWidget extends StatefulWidget {
  final GroupCalendarModel model;

  GroupCalendarWidget({required this.model});

  @override
  _GroupCalendarWidgetState createState() => _GroupCalendarWidgetState();
}

class _GroupCalendarWidgetState extends State<GroupCalendarWidget> {
  @override
  Widget build(BuildContext context) {
    // カレンダーの細かい設定値は必要に応じて変更可
    return TableCalendar(
      firstDay: DateTime(1980, 1, 1),
      lastDay: DateTime(2050, 12, 31),
      focusedDay: widget.model.focusedDay,
      currentDay: DateTime.now(),
      locale: 'ja_JP',
      availableCalendarFormats: {CalendarFormat.month: ''},
      eventLoader: (day) {
        final date = DateTime(day.year, day.month, day.day, 12);
        return widget.model.events[date] ?? [];
      },
      holidayPredicate: (day) {
        final date = DateTime(day.year, day.month, day.day, 12);
        return widget.model.holidays.containsKey(date);
      },
      startingDayOfWeek: StartingDayOfWeek.sunday,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(fontSize: 12.0, color: Colors.deepOrange[300]),
        weekdayStyle: const TextStyle(fontSize: 12.0),
      ),
      calendarStyle: CalendarStyle(
        weekendTextStyle: TextStyle(color: Colors.deepOrange[400]),
        holidayTextStyle: TextStyle(color: Colors.deepOrange[400]),
        selectedDecoration: const BoxDecoration(
          color: kSlightlyTransparentPrimaryColor,
          shape: BoxShape.circle,
        ),
        todayDecoration: const BoxDecoration(
          color: kTransparentPrimaryColor,
          shape: BoxShape.circle,
        ),
        holidayDecoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
      ),
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontSize: 18.0,
          color: kPrimaryColor,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          final date = DateTime(day.year, day.month, day.day, 12);
          final holidays = widget.model.holidays[date] ?? [];
          List<Widget> children = [];

          if (events.isNotEmpty) {
            children.add(
              const Positioned(
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
                left: 0.0,
                right: 0.0,
                child: Text(
                  holidays[0],
                  style: const TextStyle(fontSize: 8.0),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return Stack(children: children);
        },
      ),
      selectedDayPredicate: (day) {
        return isSameDay(widget.model.selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        widget.model.focusedDay = focusedDay;
        widget.model.selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 12);
        widget.model.showEventsOfDay();
      },
      onPageChanged: (focusedDay) async {
        widget.model.focusedDay = focusedDay;
        widget.model.first = DateTime(focusedDay.year, focusedDay.month, 1);
        widget.model.last = DateTime(focusedDay.year, focusedDay.month + 1, 1).subtract(const Duration(days: 1));
        try {
          await widget.model.fetchEvents();
          widget.model.fetchHolidays();
          widget.model.showEventsOfDay();
        } catch (e) {
          showMessageDialog(context, e.toString());
        }
      },
      onCalendarCreated: (pageController) async {
        try {
          await widget.model.fetchEvents();
          widget.model.fetchHolidays();
          widget.model.showEventsOfDay();
        } catch (e) {
          showMessageDialog(context, e.toString());
        }
      },
    );
  }
}
