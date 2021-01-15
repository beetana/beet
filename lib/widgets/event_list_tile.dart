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
    return Container(
      child: InkWell(
        child: Column(
          children: [
            EventPlannerImage(imageURL: imageURL, name: name),
            Expanded(
              child: Container(
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
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
              ),
            ),
            Divider(
              thickness: 0.2,
              height: 0.2,
              indent: 8.0,
              endIndent: 8.0,
              color: Colors.grey[800],
            ),
          ],
        ),
        onTap: onTap,
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
      return Padding(
        padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
        child: Row(
          children: [
            Container(
              width: 40.0,
              height: 40.0,
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
        ),
      );
    } else {
      return SizedBox(height: 40.0);
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
              '@$eventPlace',
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
