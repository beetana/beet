import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_main_model.dart';
import 'package:beet/screens/group_screens/group_event_details_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/event_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupMainScreen extends StatelessWidget {
  final String groupId;
  final double deviceWidth;
  final double textScale;
  final DateFormat dateFormat = DateFormat('y/M/d(E)', 'ja_JP');

  GroupMainScreen({
    required this.groupId,
    required this.deviceWidth,
    required this.textScale,
  });

  @override
  Widget build(BuildContext context) {
    // コメントの数字はiPhone12ProMax換算
    final double containerHeight = deviceWidth * textScale * 0.25; // 107.0
    final double dateTextSize = deviceWidth * 0.065; // 27.82
    final double scheduleTextSize = deviceWidth * 0.042; // 17.976
    final double taskCountTextSize = deviceWidth * 0.052; // 22.256
    final double textSize = deviceWidth * 0.036; // 15.408

    return ChangeNotifierProvider<GroupMainModel>(
      create: (_) => GroupMainModel()..init(groupId: groupId),
      child: Consumer<GroupMainModel>(builder: (context, model, child) {
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
                                  Text(
                                    '未完了のタスク',
                                    style: TextStyle(
                                      color: kDullGreenColor,
                                      fontSize: textSize,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        model.notCompletedTasksCount.toString(),
                                        style: TextStyle(
                                          fontSize: taskCountTextSize,
                                          color: kDullGreenColor,
                                        ),
                                      ),
                                      Text(
                                        ' 件',
                                        style: TextStyle(
                                          color: kDullGreenColor,
                                          fontSize: textSize,
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
                            await model.fetchMainInfo(groupId: groupId);
                          } catch (e) {
                            showMessageDialog(context, e.toString());
                          }
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemExtent: 64.0 * textScale,
                          itemCount: model.events.length,
                          itemBuilder: (context, index) {
                            final event = model.events[index];
                            return EventListTile(
                              event: event,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GroupEventDetailsScreen(
                                      groupId: groupId,
                                      event: event,
                                    ),
                                  ),
                                );
                                try {
                                  await model.fetchMainInfo(groupId: groupId);
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
                : model.events.isEmpty
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
