class Event {
  final String eventID;
  final String eventTitle;
  final String eventPlace;
  final String eventMemo;
  final bool isAllDay;
  final DateTime startingDateTime;
  final DateTime endingDateTime;
  final List<dynamic> dateList;

  Event({
    this.eventID,
    this.eventTitle,
    this.eventPlace,
    this.eventMemo,
    this.isAllDay,
    this.startingDateTime,
    this.endingDateTime,
    this.dateList,
  });
}
