import 'package:beet/models/group_models/group_set_list_model_3.dart';
import 'package:beet/widgets/set_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSetListScreen3 extends StatelessWidget {
  GroupSetListScreen3({
    this.setList,
    this.eventTitle,
    this.eventPlace,
    this.eventDateText,
    this.songNum,
    this.totalPlayTime,
  });
  final List<String> setList;
  final String eventTitle;
  final String eventPlace;
  final String eventDateText;
  final int songNum;
  final int totalPlayTime;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSetListModel3>(
      create: (_) => GroupSetListModel3(),
      child: Consumer<GroupSetListModel3>(builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              SafeArea(
                child: Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.0 / 1.415,
                      child: RepaintBoundary(
                        key: model.globalKey,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 16.0, right: 16.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          eventTitle,
                                          style: TextStyle(fontSize: 17.0),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          eventDateText,
                                          style: TextStyle(fontSize: 13.0),
                                        ),
                                        eventPlace.isNotEmpty
                                            ? Text(
                                                ' @$eventPlace',
                                                style:
                                                    TextStyle(fontSize: 13.0),
                                              )
                                            : Text(''),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: setList.length,
                                  itemExtent: 30.5,
                                  itemBuilder: (context, index) {
                                    return SetListTile(
                                      setList: setList,
                                      index: index,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: model.setListImage,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                '$songNum 曲',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '$totalPlayTime 分',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          height: 40.0,
                          child: FlatButton(
                            child: Text(
                              '戻る',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.cyan,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                            ),
                          ),
                          height: 40.0,
                          child: FlatButton(
                            child: Text(
                              '保存',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              model.createImage();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
