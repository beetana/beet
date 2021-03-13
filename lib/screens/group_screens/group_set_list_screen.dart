import 'package:beet/utilities/constants.dart';
import 'package:beet/models/group_models/group_set_list_model.dart';
import 'package:beet/screens/group_screens/group_set_list_screen_2.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:provider/provider.dart';

class GroupSetListScreen extends StatelessWidget {
  GroupSetListScreen({
    this.selectedSongs,
    this.songNum,
    this.totalPlayTime,
    this.groupId,
  });
  final List<String> selectedSongs;
  final int songNum;
  final int totalPlayTime;
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSetListModel>(
      create: (_) => GroupSetListModel()..init(selectedSongs),
      child: Consumer<GroupSetListModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('セットリスト作成'),
            centerTitle: true,
            actions: [
              FlatButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    Text(
                      'MC',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  model.addMC();
                },
              ),
            ],
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, model.setList);
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Scrollbar(
                    child: ImplicitlyAnimatedReorderableList(
                      items: model.setList,
                      areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
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
                      },
                    ),
                  ),
                ),
                ThinDivider(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('$songNum 曲'),
                          Text('$totalPlayTime 分'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: FlatButton(
                          child: Text(
                            '決定',
                            style: TextStyle(
                              color: kEnterButtonColor,
                              fontSize: 16.0,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupSetListScreen2(
                                  setList: model.setList,
                                  songNum: songNum,
                                  totalPlayTime: totalPlayTime,
                                  groupId: groupId,
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
          ),
        );
      }),
    );
  }
}
