import 'package:beet/constants.dart';
import 'package:beet/objects/event.dart';
import 'package:beet/models/group_models/group_event_details_model.dart';
import 'package:beet/screens/group_screens/group_edit_event_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/event_date_widget.dart';
import 'package:beet/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupEventDetailsScreen extends StatelessWidget {
  GroupEventDetailsScreen({this.groupId, this.event});
  final String groupId;
  final Event event;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupEventDetailsModel>(
      create: (_) => GroupEventDetailsModel()..init(event),
      child: Consumer<GroupEventDetailsModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text('イベント詳細'),
                actions: [
                  TextButton(
                    child: const Text(
                      '編集',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupEditEventScreen(
                            groupId: groupId,
                            event: model.event,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                      model.startLoading();
                      try {
                        await model.getEvent(groupId: groupId);
                      } catch (e) {
                        showMessageDialog(context, e.toString());
                      }
                      model.endLoading();
                    },
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 16.0),
                          Text(
                            model.eventTitle,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Visibility(
                            visible: model.eventPlace.isNotEmpty,
                            child: Text('@${model.eventPlace}'),
                          ),
                          const SizedBox(height: 8.0),
                          EventDateWidget(
                            isAllDay: model.isAllDay,
                            startingDateTime: model.startingDateTime,
                            endingDateTime: model.endingDateTime,
                          ),
                          const SizedBox(height: 16.0),
                          const Text('メモ'),
                          const SizedBox(height: 4.0),
                          BasicDivider(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: Container(
                              width: double.infinity,
                              child: Text(model.eventMemo),
                            ),
                          ),
                        ),
                      ),
                    ),
                    BasicDivider(
                      indent: 16.0,
                      endIndent: 16.0,
                    ),
                    Center(
                      child: TextButton(
                        child: const Text(
                          '削除',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                        onPressed: () async {
                          bool isDelete = await _confirmDeleteDialog(
                              context, 'このイベントを削除しますか？');
                          if (isDelete == true) {
                            model.startLoading();
                            try {
                              await model.deleteEvent(groupId: groupId);
                              Navigator.pop(context);
                            } catch (e) {
                              showMessageDialog(context, e.toString());
                            }
                            model.endLoading();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            LoadingIndicator(isLoading: model.isLoading),
          ],
        );
      }),
    );
  }
}

Future _confirmDeleteDialog(context, message) async {
  bool _isDelete;
  _isDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text(
              'キャンセル',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text(
              '削除',
              style: kDeleteButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
  return _isDelete;
}
