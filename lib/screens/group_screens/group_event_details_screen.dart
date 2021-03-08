import 'package:beet/constants.dart';
import 'package:beet/event.dart';
import 'package:beet/models/group_models/group_event_details_model.dart';
import 'package:beet/screens/group_screens/group_edit_event_screen.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/event_date_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupEventDetailsScreen extends StatelessWidget {
  GroupEventDetailsScreen({this.groupID, this.event});
  final String groupID;
  final Event event;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupEventDetailsModel>(
      create: (_) => GroupEventDetailsModel()..init(event),
      child: Consumer<GroupEventDetailsModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('イベント詳細'),
            centerTitle: true,
            actions: <Widget>[
              FlatButton(
                child: Text(
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
                        groupID: groupID,
                        event: model.event,
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                  model.startLoading();
                  try {
                    await model.getEvent(groupID: groupID);
                  } catch (e) {
                    _showTextDialog(context, e.toString());
                  }
                  model.endLoading();
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 16.0),
                          Text(
                            model.eventTitle,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Visibility(
                            visible: model.eventPlace.isNotEmpty,
                            child: Text('@${model.eventPlace}'),
                          ),
                          SizedBox(height: 8.0),
                          EventDateWidget(
                            isAllDay: model.isAllDay,
                            startingDateTime: model.startingDateTime,
                            endingDateTime: model.endingDateTime,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'メモ',
                          ),
                          SizedBox(height: 4.0),
                          BasicDivider(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                    SizedBox(height: 8.0),
                    Center(
                      child: FlatButton(
                        child: Text(
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
                              await model.deleteEvent(groupID: groupID);
                              Navigator.pop(context);
                            } catch (e) {
                              _showTextDialog(context, e.toString());
                            }
                            model.endLoading();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              model.isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
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
        actions: <Widget>[
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

Future _confirmDeleteDialog(context, message) async {
  bool _isDelete;
  _isDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'キャンセル',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text(
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
