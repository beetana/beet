import 'package:beet/utilities/constants.dart';
import 'package:beet/models/user_models/user_main_model.dart';
import 'package:beet/screens/user_screens/user_event_details_screen.dart';
import 'package:beet/widgets/event_list_tile.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserMainScreen extends StatelessWidget {
  UserMainScreen({this.userId});
  final String userId;
  final dateFormat = DateFormat('y/M/d(E)', 'ja_JP');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserMainModel>(
      create: (_) => UserMainModel()..init(userId: userId),
      child: Consumer<UserMainModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 112.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                                        model.taskCount.toString(),
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
                  ThinDivider(),
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemExtent: 96.0,
                        itemCount: model.eventList.length,
                        itemBuilder: (context, index) {
                          final event = model.eventList[index];
                          return EventListTile(
                            event: event,
                            imageURL:
                                model.eventPlanner[event.ownerId].imageURL,
                            name: model.eventPlanner[event.ownerId].name,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserEventDetailsScreen(
                                    userId: userId,
                                    event: event,
                                  ),
                                ),
                              );
                              model.startLoading();
                              try {
                                await model.getEventList(userId: userId);
                              } catch (e) {
                                _showTextDialog(context, e.toString());
                              }
                              model.endLoading();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            model.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : model.eventList.isEmpty
                    ? Center(
                        child: Text('予定されているイベントはありません'),
                      )
                    : SizedBox(),
          ],
        );
      }),
    );
  }
}

Future _showTextDialog(context, message) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
