import 'package:beet/constants.dart';
import 'package:beet/objects/event.dart';
import 'package:beet/models/user_models/user_event_details_model.dart';
import 'package:beet/screens/user_screens/user_edit_event_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/event_date_widget.dart';
import 'package:beet/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEventDetailsScreen extends StatelessWidget {
  final Event event;

  UserEventDetailsScreen({this.event});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserEventDetailsModel>(
      create: (_) => UserEventDetailsModel()..init(event: event),
      child: Consumer<UserEventDetailsModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text('イベントの詳細'),
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
                          builder: (context) =>
                              UserEditEventScreen(event: model.event),
                          fullscreenDialog: true,
                        ),
                      );
                      model.startLoading();
                      try {
                        await model.fetchEvent();
                      } catch (e) {
                        showMessageDialog(context, e.toString());
                      }
                      model.endLoading();
                    },
                  ),
                ],
              ),
              body: model.owner != null
                  ? SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    Container(
                                      width: 32.0,
                                      height: 32.0,
                                      child: CircleAvatar(
                                        backgroundImage: model.owner.imageURL ==
                                                null
                                            ? model.isOwn
                                                ? const AssetImage(
                                                    'images/user_profile.png')
                                                : const AssetImage(
                                                    'images/group_profile.png')
                                            : model.owner.imageURL.isNotEmpty
                                                ? NetworkImage(
                                                    model.owner.imageURL)
                                                : model.isOwn
                                                    ? const AssetImage(
                                                        'images/user_profile.png')
                                                    : const AssetImage(
                                                        'images/group_profile.png'),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(model.owner.name),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  model.eventTitle,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Visibility(
                                  visible: model.eventPlace.isNotEmpty,
                                  child: Text(model.eventPlace),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
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
                                    await model.deleteEvent();
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
                    )
                  : const SizedBox(),
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
