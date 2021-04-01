import 'package:beet/constants.dart';
import 'package:beet/models/user_models/user_main_model.dart';
import 'package:beet/screens/user_screens/user_event_details_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/event_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserMainScreen extends StatelessWidget {
  UserMainScreen({this.userId});
  final String userId;
  final dateFormat = DateFormat('y/M/d(E)', 'ja_JP');

  @override
  Widget build(BuildContext context) {
    // コメントの数字はiPhone12ProMax換算
    final double deviceWidth = MediaQuery.of(context).size.width; // 428
    final double containerHeight = deviceWidth * 0.26; // 111.28
    final double dateTextSize = deviceWidth * 0.065; // 27.82
    final double scheduleTextSize = deviceWidth * 0.042; // 17.976
    final double taskCountTextSize = deviceWidth * 0.056; // 23.968

    return ChangeNotifierProvider<UserMainModel>(
      create: (_) => UserMainModel()..init(userId: userId),
      child: Consumer<UserMainModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Container(
                    height: containerHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateFormat.format(model.currentDateTime),
                            style: TextStyle(
                              fontSize: dateTextSize,
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
                                  fontSize: scheduleTextSize,
                                  fontWeight: FontWeight.w500,
                                  color: kPrimaryColor,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
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
                                          fontSize: taskCountTextSize,
                                          color: kDullGreenColor,
                                        ),
                                      ),
                                      const Text(
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
                      child: RefreshIndicator(
                        onRefresh: () async {
                          try {
                            await model.getEventList(userId: userId);
                          } catch (e) {
                            showMessageDialog(context, e.toString());
                          }
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
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
                                    builder: (context) =>
                                        UserEventDetailsScreen(
                                      userId: userId,
                                      event: event,
                                    ),
                                  ),
                                );
                                try {
                                  await model.getEventList(userId: userId);
                                } catch (e) {
                                  showMessageDialog(context, e.toString());
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            model.isLoading
                ? Container(
                    color: Colors.transparent,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : model.eventList.isEmpty
                    ? const Center(
                        child: Text('予定されているイベントはありません'),
                      )
                    : const SizedBox(),
          ],
        );
      }),
    );
  }
}
