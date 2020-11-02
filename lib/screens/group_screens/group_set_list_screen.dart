import 'package:beet/models/group_models/group_set_list_model.dart';
import 'package:beet/screens/group_screens/group_set_list_screen_2.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:provider/provider.dart';

class GroupSetListScreen extends StatelessWidget {
  GroupSetListScreen({this.selectedSongs, this.songNum, this.totalPlayTime});
  final List<String> selectedSongs;
  final int songNum;
  final int totalPlayTime;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSetListModel>(
      create: (_) => GroupSetListModel()..init(selectedSongs),
      child: Consumer<GroupSetListModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, model.setList);
              },
            ),
            title: Text('セットリスト作成'),
          ),
          body: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Flexible(
                    child: ImplicitlyAnimatedReorderableList(
                        items: model.setList,
                        areItemsTheSame: (oldItem, newItem) =>
                            oldItem == newItem,
                        onReorderFinished: (song, from, to, songs) {
                          model.setList = songs;
                        },
                        itemBuilder: (context, animation, song, index) {
                          return Reorderable(
                            key: ValueKey(song),
                            builder: (context, animation, bool) {
                              return Material(
                                type: MaterialType.transparency,
                                child: ListTile(
                                  title: Text(
                                    '$song',
                                    maxLines: 1,
                                  ),
                                  trailing: Handle(
                                    delay: Duration(milliseconds: 100),
                                    child: Icon(
                                      Icons.list,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                ],
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
                            color: Colors.black54,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          height: 40.0,
                          child: FlatButton(
                            child: Text(
                              'MC追加',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              model.addMC();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                            ),
                          ),
                          height: 40.0,
                          child: FlatButton(
                            child: Text(
                              '決定',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupSetListScreen2(
                                    setList: model.setList,
                                    songNum: songNum,
                                    totalPlayTime: totalPlayTime,
                                  ),
                                ),
                              );
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
