import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListTile extends StatelessWidget {
  final String eventTitle;
  final String eventPlace;
  final bool isAllDay;
  final DateTime startingDateTime;
  final DateTime endingDateTime;
  final Function onTap;
  final DateFormat dateFormat = DateFormat('M/d');
  final DateFormat timeFormat = DateFormat('H:mm');

  EventListTile({
    this.eventTitle,
    this.eventPlace,
    this.isAllDay,
    this.startingDateTime,
    this.endingDateTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Material(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10.0),
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(eventTitle),
                      Visibility(
                        visible: eventPlace.isNotEmpty,
                        child: Text(
                          '@ $eventPlace',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  EventDateTimeWidget(
                      isAllDay: isAllDay,
                      dateFormat: dateFormat,
                      startingDateTime: startingDateTime,
                      endingDateTime: endingDateTime,
                      timeFormat: timeFormat),
                ],
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

class EventDateTimeWidget extends StatelessWidget {
  EventDateTimeWidget({
    @required this.isAllDay,
    @required this.dateFormat,
    @required this.startingDateTime,
    @required this.endingDateTime,
    @required this.timeFormat,
  });

  final bool isAllDay;
  final DateTime startingDateTime;
  final DateTime endingDateTime;
  final DateFormat dateFormat;
  final DateFormat timeFormat;

  @override
  Widget build(BuildContext context) {
    if (isAllDay == false) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(dateFormat.format(startingDateTime)),
                Text('~ ${dateFormat.format(endingDateTime)}'),
              ],
            ),
            SizedBox(
              width: 8.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(timeFormat.format(startingDateTime)),
                Text(timeFormat.format(endingDateTime)),
              ],
            ),
          ],
        ),
      );
    } else if (dateFormat.format(startingDateTime) ==
        dateFormat.format(endingDateTime)) {
      return Text(dateFormat.format(startingDateTime));
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(dateFormat.format(startingDateTime)),
          Text('~ ${dateFormat.format(endingDateTime)}'),
        ],
      );
    }
  }
}
