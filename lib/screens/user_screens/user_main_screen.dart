import 'package:beet/constants.dart';
import 'package:beet/models/user_models/user_main_model.dart';
import 'package:beet/screens/user_screens/user_event_screen.dart';
import 'package:beet/widgets/user_event_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserMainScreen extends StatelessWidget {
  UserMainScreen({this.userID});
  final String userID;
  final dateFormat = DateFormat('y/M/d(E)', 'ja_JP');
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserMainModel>(
      create: (_) => UserMainModel()..getEventList(userID),
      child: Consumer<UserMainModel>(builder: (context, model, child) {
        if (model.eventList.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                ),
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Expanded(
                  flex: 4,
                  child: Scrollbar(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemExtent: 96.0,
                      itemCount: model.eventList.length,
                      itemBuilder: (context, index) {
                        final event = model.eventList[index];
                        return UserEventListTile(
                          imageURL: model.eventPlanner[event.myID].imageURL,
                          name: model.eventPlanner[event.myID].name,
                          eventTitle: event.eventTitle,
                          eventPlace: event.eventPlace,
                          isAllDay: event.isAllDay,
                          startingDateTime: event.startingDateTime,
                          endingDateTime: event.endingDateTime,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserEventScreen(
                                  userID: userID,
                                  event: event,
                                ),
                              ),
                            );
                            await model.getEventList(userID);
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
            child: Text('イベントがありません'),
          );
        }
      }),
    );
  }
}
