import 'package:beet/screens/group_screens/group_add_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:beet/models/group_models/group_calendar_model.dart';
import 'package:beet/widgets/add_floating_action_button.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class GroupCalendarScreen extends StatelessWidget {
  GroupCalendarScreen({this.groupID});
  final String groupID;
  final calendarController = CalendarController();
  final Map<DateTime, List> events = {};
  final Map<DateTime, List> _holidays = {
    DateTime(2019, 1, 1): ['New Year\'s Day'],
    DateTime(2019, 2, 14): ['Valentine\'s Day'],
  };
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupCalendarModel>(
      create: (_) => GroupCalendarModel()..init(),
      child: Consumer<GroupCalendarModel>(builder: (context, model, child) {
        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                TableCalendar(
                  locale: 'ja_JA',
                  calendarController: calendarController,
                  availableCalendarFormats: {CalendarFormat.month: 'Month'},
                  events: events,
                  holidays: _holidays,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  calendarStyle: CalendarStyle(
                    weekendStyle: TextStyle(color: Colors.black45),
                    selectedColor: Colors.cyan[400],
                    todayColor: Colors.cyan[200],
                    markersColor: Colors.brown[700],
                    outsideDaysVisible: false,
                  ),
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonVisible: false,
                  ),
                  onDaySelected: (DateTime day, List events) {
                    model.selectedDay = day;
                  },
                  onVisibleDaysChanged:
                      (DateTime first, DateTime last, CalendarFormat format) {},
                  onCalendarCreated:
                      (DateTime first, DateTime last, CalendarFormat format) {},
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  AddFloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupAddEventScreen(
                            groupID: groupID,
                            dateTime: model.selectedDay,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

//import 'package:flutter/material.dart';
//import 'package:intl/date_symbol_data_local.dart';
//import 'package:table_calendar/table_calendar.dart';
//
//final Map<DateTime, List> _holidays = {
//  DateTime(2019, 1, 1): ['New Year\'s Day'],
//  DateTime(2019, 2, 14): ['Valentine\'s Day'],
//};
//
//void main() {
//  initializeDateFormatting().then((_) => runApp(MyApp()));
//}
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: MyHomePage(),
//    );
//  }
//}
//
//class MyHomePage extends StatefulWidget {
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
//  Map<DateTime, List> _events;
//  List _selectedEvents;
//  AnimationController _animationController;
//  CalendarController _calendarController;
//
//  @override
//  void initState() {
//    super.initState();
//    final _selectedDay = DateTime.now();
//
//    _events = {
//      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
//      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4'],
//      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
//      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
//      _selectedDay.add(Duration(days: 3)):
//      Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
//      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
//    };
//
//    _selectedEvents = _events[_selectedDay] ?? [];
//    _calendarController = CalendarController();
//    _animationController = AnimationController(
//      vsync: this,
//      duration: const Duration(milliseconds: 400),
//    );
//    _animationController.forward();
//  }
//
//  @override
//  void dispose() {
//    _animationController.dispose();
//    _calendarController.dispose();
//    super.dispose();
//  }
//
//  void _onDaySelected(DateTime day, List events) {
//    print('CALLBACK: _onDaySelected');
//    setState(() {
//      _selectedEvents = events;
//    });
//  }
//
//  void _onVisibleDaysChanged(
//      DateTime first, DateTime last, CalendarFormat format) {
//    print('CALLBACK: _onVisibleDaysChanged');
//  }
//
//  void _onCalendarCreated(
//      DateTime first, DateTime last, CalendarFormat format) {
//    print('CALLBACK: _onCalendarCreated');
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Column(
//        mainAxisSize: MainAxisSize.max,
//        children: <Widget>[
////          _buildTableCalendar(),
//          _buildTableCalendarWithBuilders(),
//          Expanded(child: _buildEventList()),
//        ],
//      ),
//    );
//  }
//
//  // Simple TableCalendar configuration (using Styles)
//  Widget _buildTableCalendar() {
//    return TableCalendar(
//      calendarController: _calendarController,
//      events: _events,
//      holidays: _holidays,
//      startingDayOfWeek: StartingDayOfWeek.monday,
//      calendarStyle: CalendarStyle(
//        selectedColor: Colors.deepOrange[400],
//        todayColor: Colors.deepOrange[200],
//        markersColor: Colors.brown[700],
//        outsideDaysVisible: false,
//      ),
//      headerStyle: HeaderStyle(
//        formatButtonTextStyle:
//        TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
//        formatButtonDecoration: BoxDecoration(
//          color: Colors.deepOrange[400],
//          borderRadius: BorderRadius.circular(16.0),
//        ),
//      ),
//      onDaySelected: _onDaySelected,
//      onVisibleDaysChanged: _onVisibleDaysChanged,
//      onCalendarCreated: _onCalendarCreated,
//    );
//  }
//
//  Widget _buildTableCalendarWithBuilders() {
//    return TableCalendar(
//      locale: 'pl_PL',
//      calendarController: _calendarController,
//      events: _events,
//      holidays: _holidays,
//      initialCalendarFormat: CalendarFormat.month,
//      formatAnimation: FormatAnimation.slide,
//      startingDayOfWeek: StartingDayOfWeek.sunday,
//      availableGestures: AvailableGestures.all,
//      availableCalendarFormats: const {
//        CalendarFormat.month: '',
//        CalendarFormat.week: '',
//      },
//      calendarStyle: CalendarStyle(
//        outsideDaysVisible: false,
//        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
//        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
//      ),
//      daysOfWeekStyle: DaysOfWeekStyle(
//        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
//      ),
//      headerStyle: HeaderStyle(
//        centerHeaderTitle: true,
//        formatButtonVisible: false,
//      ),
//      builders: CalendarBuilders(
//        selectedDayBuilder: (context, date, _) {
//          return FadeTransition(
//            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
//            child: Container(
//              margin: const EdgeInsets.all(4.0),
//              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//              color: Colors.deepOrange[300],
//              width: 100,
//              height: 100,
//              child: Text(
//                '${date.day}',
//                style: TextStyle().copyWith(fontSize: 16.0),
//              ),
//            ),
//          );
//        },
//        todayDayBuilder: (context, date, _) {
//          return Container(
//            margin: const EdgeInsets.all(4.0),
//            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//            color: Colors.amber[400],
//            width: 100,
//            height: 100,
//            child: Text(
//              '${date.day}',
//              style: TextStyle().copyWith(fontSize: 16.0),
//            ),
//          );
//        },
//        markersBuilder: (context, date, events, holidays) {
//          final children = <Widget>[];
//
//          if (events.isNotEmpty) {
//            children.add(
//              Positioned(
//                right: 1,
//                bottom: 1,
//                child: _buildEventsMarker(date, events),
//              ),
//            );
//          }
//
//          if (holidays.isNotEmpty) {
//            children.add(
//              Positioned(
//                right: -2,
//                top: -2,
//                child: _buildHolidaysMarker(),
//              ),
//            );
//          }
//
//          return children;
//        },
//      ),
//      onDaySelected: (date, events) {
//        _onDaySelected(date, events);
//        _animationController.forward(from: 0.0);
//      },
//      onVisibleDaysChanged: _onVisibleDaysChanged,
//      onCalendarCreated: _onCalendarCreated,
//    );
//  }
//
//  Widget _buildEventsMarker(DateTime date, List events) {
//    return AnimatedContainer(
//      duration: const Duration(milliseconds: 300),
//      decoration: BoxDecoration(
//        shape: BoxShape.rectangle,
//        color: _calendarController.isSelected(date)
//            ? Colors.brown[500]
//            : _calendarController.isToday(date)
//            ? Colors.brown[300]
//            : Colors.blue[400],
//      ),
//      width: 16.0,
//      height: 16.0,
//      child: Center(
//        child: Text(
//          '${events.length}',
//          style: TextStyle().copyWith(
//            color: Colors.white,
//            fontSize: 12.0,
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget _buildHolidaysMarker() {
//    return Icon(
//      Icons.add_box,
//      size: 20.0,
//      color: Colors.blueGrey[800],
//    );
//  }
//
//  Widget _buildEventList() {
//    return ListView(
//      children: _selectedEvents
//          .map((event) => Container(
//        color: Colors.grey,
//        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//        child: ListTile(
//          title: Text(event.toString()),
//          onTap: () => print('$event tapped!'),
//        ),
//      ))
//          .toList(),
//    );
//  }
//}
