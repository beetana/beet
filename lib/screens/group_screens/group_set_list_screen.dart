import 'package:beet/song.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';

class GroupSetListScreen extends StatelessWidget {
  GroupSetListScreen({this.setList, this.songNum, this.totalPlayTime});
  final List<Song> setList;
  final int songNum;
  final int totalPlayTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('セットリスト作成'),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                child: ImplicitlyAnimatedReorderableList(
                    items: setList,
                    areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
                    onReorderFinished: (song, from, to, songs) {},
                    itemBuilder: (context, animation, song, index) {
                      return Reorderable(
                        key: ValueKey(song),
                        builder: (context, animation, bool) {
                          return Material(
                            type: MaterialType.transparency,
                            child: ListTile(
                              title: Text(
                                '${index + 1}.  ${song.title}',
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
                          color: Colors.cyan,
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
                          onPressed: () {},
                        ),
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
