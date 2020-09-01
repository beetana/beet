import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListTile extends StatelessWidget {
  final String eventID;
  final String eventTitle;
  final String eventPlace;
  final String eventMemo;
  final DateTime startingDateTime;
  final DateTime endingDateTime;
  final Function onTap;
  final DateFormat dateFormat = DateFormat("M/d");
  final DateFormat timeFormat = DateFormat("H:mm");

  EventListTile({
    this.eventID,
    this.eventTitle,
    this.eventPlace,
    this.eventMemo,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(eventTitle),
                      Text(
                        '@ $eventPlace',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(dateFormat.format(startingDateTime)),
                            Text(dateFormat.format(endingDateTime)),
                          ],
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('${timeFormat.format(startingDateTime)} ~'),
                            Text(timeFormat.format(endingDateTime)),
                          ],
                        ),
                      ],
                    ),
                  ),
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
