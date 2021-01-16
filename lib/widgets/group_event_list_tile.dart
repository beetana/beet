import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupEventListTile extends StatelessWidget {
  GroupEventListTile({
    @required this.eventTitle,
    @required this.eventPlace,
    @required this.isAllDay,
    @required this.startingDateTime,
    @required this.endingDateTime,
    @required this.onTap,
  });

  final String eventTitle;
  final String eventPlace;
  final bool isAllDay;
  final DateTime startingDateTime;
  final DateTime endingDateTime;
  final Function onTap;
  final DateFormat dateFormat = DateFormat('M/d');
  final DateFormat timeFormat = DateFormat('H:mm');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventTitleWidget(eventTitle: eventTitle),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  EventPlaceWidget(
                    eventPlace: eventPlace,
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
          ),
          Divider(
            thickness: 0.1,
            height: 0.1,
            indent: 8.0,
            endIndent: 8.0,
            color: Colors.grey[800],
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

class EventTitleWidget extends StatelessWidget {
  EventTitleWidget({@required this.eventTitle});

  final String eventTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0, left: 24.0, right: 24.0),
      child: Text(
        eventTitle,
        style: TextStyle(fontSize: 18.0),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class EventPlaceWidget extends StatelessWidget {
  EventPlaceWidget({@required this.eventPlace});

  final String eventPlace;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: eventPlace.isNotEmpty
          ? Text(
              '@$eventPlace',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
              ),
              overflow: TextOverflow.ellipsis,
            )
          : SizedBox(),
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
      return Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                dateFormat.format(startingDateTime),
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 4.0),
              Text(
                '~ ${dateFormat.format(endingDateTime)}',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          SizedBox(width: 4.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                timeFormat.format(startingDateTime),
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 4.0),
              Text(
                timeFormat.format(endingDateTime),
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ],
      );
    } else if (dateFormat.format(startingDateTime) ==
        dateFormat.format(endingDateTime)) {
      return Text(
        dateFormat.format(startingDateTime),
        style: TextStyle(fontSize: 16.0),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            dateFormat.format(startingDateTime),
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 4.0),
          Text(
            '~ ${dateFormat.format(endingDateTime)}',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      );
    }
  }
}
