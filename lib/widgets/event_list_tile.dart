import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListTile extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          this.imageURL != null
              ? Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
                  child: EventPlannerImage(imageURL: imageURL, name: name),
                )
              : SizedBox(
                  height: 8.0,
                ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  EventOverView(
                    eventTitle: eventTitle,
                    eventPlace: eventPlace,
                  ),
                  EventDateTime(
                      isAllDay: isAllDay,
                      dateFormat: dateFormat,
                      startingDateTime: startingDateTime,
                      endingDateTime: endingDateTime,
                      timeFormat: timeFormat),
                ],
              ),
            ),
          ),
          ThinDivider(
            indent: 16.0,
            endIndent: 16.0,
          ),
        ],
      ),
    );
  }
}

class EventPlannerImage extends StatelessWidget {
  EventPlannerImage({
    this.imageURL,
    this.name,
  });

  final String imageURL;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32.0,
          height: 32.0,
          child: CircleAvatar(
            backgroundImage: imageURL.isNotEmpty
                ? NetworkImage(imageURL)
                : AssetImage('images/test_user_image.png'),
            backgroundColor: Colors.transparent,
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class EventOverView extends StatelessWidget {
  EventOverView({
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
          overflow: TextOverflow.ellipsis,
        ),
      );
  }
}

class EventDateTime extends StatelessWidget {
  EventDateTime({
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
