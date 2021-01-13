import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListTile extends StatelessWidget {
  final String imageURL;
  final String name;
  final String eventTitle;
  final String eventPlace;
  final bool isAllDay;
  final DateTime startingDateTime;
  final DateTime endingDateTime;
  final Function onTap;
  final DateFormat dateFormat = DateFormat('M/d');
  final DateFormat timeFormat = DateFormat('H:mm');

  EventListTile({
    this.imageURL,
    this.name,
    @required this.eventTitle,
    @required this.eventPlace,
    @required this.isAllDay,
    @required this.startingDateTime,
    @required this.endingDateTime,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventPlannerImage(imageURL: imageURL, name: name),
          SizedBox(height: 5.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.4),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      EventOverViewWidget(
                        eventTitle: eventTitle,
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
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventPlannerImage extends StatelessWidget {
  final String imageURL;
  final String name;
  EventPlannerImage({
    this.imageURL,
    this.name,
  });
  @override
  Widget build(BuildContext context) {
    if (imageURL != null) {
      return Row(
        children: [
          Container(
            width: 30.0,
            height: 30.0,
            child: CircleAvatar(
              backgroundImage: imageURL.isNotEmpty
                  ? NetworkImage(imageURL)
                  : AssetImage('images/test_user_image.png'),
              backgroundColor: Colors.transparent,
            ),
          ),
          SizedBox(width: 5.0),
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}

class EventOverViewWidget extends StatelessWidget {
  EventOverViewWidget({
    @required this.eventTitle,
    @required this.eventPlace,
  });

  final String eventTitle;
  final String eventPlace;

  @override
  Widget build(BuildContext context) {
    if (eventPlace.isNotEmpty) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              eventTitle,
              style: TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '@ $eventPlace',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    } else
      return Expanded(
        child: Text(
          eventTitle,
          style: TextStyle(fontSize: 16.0),
          overflow: TextOverflow.ellipsis,
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
      return Row(
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
