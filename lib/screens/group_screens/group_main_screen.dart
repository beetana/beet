import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_main_model.dart';
import 'package:beet/screens/group_screens/group_event_screen.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/event_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupMainScreen extends StatelessWidget {
  GroupMainScreen({this.groupID});
  final String groupID;
  final dateFormat = DateFormat('y/M/d(E)', 'ja_JP');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupMainModel>(
      create: (_) => GroupMainModel()..getEventList(groupID),
      child: Consumer<GroupMainModel>(builder: (context, model, child) {
        if (model.eventList.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Container(
                  height: 112.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          dateFormat.format(model.currentDateTime),
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w500,
                            color: kPrimaryColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'スケジュール',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: kPrimaryColor,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '未完了のタスク',
                                  style: TextStyle(
                                    color: kDullGreenColor,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '3',
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        color: kDullGreenColor,
                                      ),
                                    ),
                                    Text(
                                      '件',
                                      style: TextStyle(
                                        color: kDullGreenColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                BasicDivider(),
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemExtent: 64.0,
                      itemCount: model.eventList.length,
                      itemBuilder: (context, index) {
                        final event = model.eventList[index];
                        return EventListTile(
                          eventTitle: event.eventTitle,
                          eventPlace: event.eventPlace,
                          isAllDay: event.isAllDay,
                          startingDateTime: event.startingDateTime,
                          endingDateTime: event.endingDateTime,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupEventScreen(
                                  groupID: groupID,
                                  event: event,
                                ),
                              ),
                            );
                            await model.getEventList(groupID);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (model.isLoading == true) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text('予定されているイベントはありません'),
          );
        }
      }),
    );
  }
}
