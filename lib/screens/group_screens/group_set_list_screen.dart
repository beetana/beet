import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_set_list_model.dart';
import 'package:beet/screens/group_screens/group_set_list_screen_2.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:provider/provider.dart';

class GroupSetListScreen extends StatelessWidget {
  final List<dynamic> setList; // setListに入るのはSongもしくはMC
  final String groupId;

  GroupSetListScreen({this.setList, this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSetListModel>(
      create: (_) => GroupSetListModel()..init(setList: setList),
      child: Consumer<GroupSetListModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('セットリスト'),
            actions: [
              TextButton(
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    const Text(
                      'MC',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  // セットリストを一枚の画像にバランス良く収めるための上限が14曲
                  model.setList.length >= 14
                      ? showMessageDialog(context, '作成できるセットリストは14曲まで(MC含む)です。')
                      : model.addMC();
                },
              ),
            ],
            leading: IconButton(
              icon: const Icon(
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
                                  item.title,
                                  maxLines: 1,
                                ),
                                trailing: const Handle(
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
                          child: const Text(
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
