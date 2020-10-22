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
        return Stack(
          children: [
            Scaffold(
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
                            event: event,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                      await model.getEvent(groupID: groupID);
                    },
                  ),
                ],
              ),
              body: Padding(
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
                  ],
                ),
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
        );
      }),
    );
  }
}
