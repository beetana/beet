import 'package:beet/event.dart';
import 'package:beet/models/user_models/user_event_model.dart';
import 'package:beet/screens/user_screens/user_edit_event_screen.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEventScreen extends StatelessWidget {
  UserEventScreen({this.userID, this.event});
  final String userID;
  final Event event;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserEventModel>(
      create: (_) => UserEventModel()..init(event),
      child: Consumer<UserEventModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('イベント詳細'),
            centerTitle: true,
            actions: <Widget>[
              Visibility(
                visible: model.myID == userID,
                child: FlatButton(
                  child: Text(
                    '編集',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserEditEventScreen(
                          userID: userID,
                          event: model.event,
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                    model.startLoading();
                    try {
                      await model.getEvent(userID: userID);
                    } catch (e) {
                      _showTextDialog(context, e.toString());
                    }
                    model.endLoading();
                  },
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 16.0),
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
                      BasicDivider(),
                      SizedBox(height: 10.0),
                      model.eventMemoWidget(),
                      SizedBox(height: 56.0),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: model.myID == userID,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 40.0,
                      width: double.infinity,
                      color: Colors.redAccent,
                      child: FlatButton(
                        child: Text(
                          '削除',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          bool isDelete = await _confirmDeleteDialog(
                              context, 'このイベントを削除しますか？');
                          if (isDelete == true) {
                            model.startLoading();
                            try {
                              await model.deleteEvent(userID: userID);
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
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
            Radius.circular(10.0),
          ),
        ),
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'キャンセル',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text(
              '削除',
              style: TextStyle(
                color: Colors.redAccent,
              ),
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
