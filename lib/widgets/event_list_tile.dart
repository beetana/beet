import 'package:beet/objects/event.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListTile extends StatelessWidget {
  final Event event;
  final Function onTap;
  final String imageURL;
  final String name;
  final bool isOwn;
  final double textScale;
  final DateFormat dateFormat = DateFormat('M/d');
  final DateFormat timeFormat = DateFormat('H:mm');

  EventListTile({
    @required this.event,
    @required this.onTap,
    this.imageURL,
    this.name,
    this.isOwn,
    this.textScale,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          this.imageURL != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
                  child: EventPlannerImage(
                    imageURL: imageURL,
                    name: name,
                    textScale: textScale,
                    isOwn: isOwn,
                  ),
                )
              : const SizedBox(height: 8.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  EventOverView(
                    eventTitle: event.title,
                    eventPlace: event.place,
                  ),
                  EventDateTime(
                      isAllDay: event.isAllDay,
                      dateFormat: dateFormat,
                      startingDateTime: event.startingDateTime,
                      endingDateTime: event.endingDateTime,
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
  final String imageURL;
  final String name;
  final double textScale;
  final bool isOwn;

  EventPlannerImage({this.imageURL, this.name, this.textScale, this.isOwn});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32.0 * textScale,
          height: 32.0 * textScale,
          child: CircleAvatar(
            backgroundImage: imageURL.isNotEmpty
                ? NetworkImage(imageURL)
                : isOwn
                    ? const AssetImage('images/user_profile.png')
                    : const AssetImage('images/group_profile.png'),
            backgroundColor: Colors.transparent,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w500),
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
              '$eventPlace',
              style: const TextStyle(
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
    if (!isAllDay) {
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
          const SizedBox(width: 8.0),
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
