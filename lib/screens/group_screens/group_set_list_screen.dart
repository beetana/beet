import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_set_list_model.dart';
import 'package:beet/screens/group_screens/group_set_list_screen_2.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:provider/provider.dart';
import 'package:beet/objects/song.dart';

class GroupSetListScreen extends StatelessWidget {
  final List<dynamic> setList;
  final String groupId;

  GroupSetListScreen({this.setList, this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSetListModel>(
      create: (_) => GroupSetListModel()..init(setList: setList),
      child: Consumer<GroupSetListModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('セットリストを作成'),
            actions: [
              TextButton(
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
                      onReorderFinished: (item, from, to, setList) {
                        model.setList = setList;
                      },
                      itemBuilder: (context, animation, item, index) {
                        return Reorderable(
                          key: ValueKey(item),
                          builder: (context, animation, bool) {
                            return Material(
                              type: MaterialType.transparency,
                              child: ListTile(
                                title: Text(
                                  item is Song ? item.title : item,
                                  maxLines: 1,
                                ),
                                trailing: Handle(
                                  delay: Duration(milliseconds: 100),
                                  child: Icon(
                                    Icons.list,
                                    color: Colors.black54,
                                  ),
                                ),
                                onLongPress: () {
                                  model.removeItem(item: item);
                                  if (model.setList.isEmpty) {
                                    Navigator.pop(context, model.setList);
                                  }
                                },
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
                          Text('${model.songCount} 曲'),
                          Text('${model.totalPlayTime} 分'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: TextButton(
                          child: Text(
                            '次へ',
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
                                  songCount: model.songCount,
                                  totalPlayTime: model.totalPlayTime,
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
