import 'package:beet/event.dart';
import 'package:beet/models/group_models/group_event_model.dart';
import 'package:beet/screens/group_screens/group_edit_event_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupEventScreen extends StatelessWidget {
  GroupEventScreen({this.groupID, this.event});
  final String groupID;
  final Event event;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupEventModel>(
      create: (_) => GroupEventModel()..init(event),
      child: Consumer<GroupEventModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('イベント詳細'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  '編集',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
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
              Padding(
                padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      model.eventTitle,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Visibility(
                      visible: model.eventPlace.isNotEmpty,
                      child: Text('@${model.eventPlace}'),
                    ),
                    SizedBox(height: 20.0),
                    model.eventDateWidget(),
                    SizedBox(height: 10.0),
                    Divider(height: 0.5),
                    SizedBox(height: 10.0),
                    model.eventMemoWidget(),
                    Expanded(
                      child: SizedBox(),
                    ),
                    SizedBox(height: 40.0),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: double.infinity,
                    color: Colors.red,
                    child: FlatButton(
                      child: Text('イベントを削除'),
                      onPressed: () async {
                        bool isDelete =
                            await _confirmDeleteDialog(context, '削除しますか？');
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('キャンセル'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text('削除'),
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
