import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListTile extends StatelessWidget {
  final String eventTitle;
  final String eventPlace;
  final String eventMemo;
  final DateTime startingDateTime;
  final DateTime endingDateTime;
  final dateFormat = DateFormat("M/d h:mm");

  EventListTile({
    this.eventTitle,
    this.eventPlace,
    this.eventMemo,
    this.startingDateTime,
    this.endingDateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        trailing: Text(
          '${dateFormat.format(startingDateTime)} ~\n${dateFormat.format(endingDateTime)}',
        ),
        title: Text(
          eventTitle,
        ),
        subtitle: Text('@ $eventPlace'),
      ),
    );
  }
}
