import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_set_list_model.dart';
import 'package:beet/objects/set_list.dart';
import 'package:beet/screens/group_screens/group_set_list_screen_2.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/sized_app_bar.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSetListScreen extends StatelessWidget {
  final List<SetList> setList;
  final String groupId;

  GroupSetListScreen({required this.setList, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSetListModel>(
      create: (_) => GroupSetListModel()..init(setList: setList),
      child: Consumer<GroupSetListModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: SizedAppBar(
            title: 'セットリスト',
            actions: [
              TextButton(
                child: const Row(
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
                  // セットリストを一枚の画像にバランス良く収めるための上限が14曲
                  model.setList.length >= 14 ? showMessageDialog(context, '作成できるセットリストは14曲まで(MC含む)です。') : model.addMC();
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
                    child: ReorderableListView(
                      children: List.generate(
                        model.setList.length,
                        (index) {
                          final item = model.setList[index];
                          return Dismissible(
                            key: ValueKey(item),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              model.removeItem(item: item);
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: ListTile(
                              key: ValueKey(item),
                              title: Text(
                                item.title,
                                maxLines: 1,
                              ),
                              trailing: ReorderableDragStartListener(
                                index: index,
                                child: const Icon(Icons.drag_handle),
                              ),
                            ),
                          );
                        },
                      ),
                      onReorder: (int oldIndex, int newIndex) {
                        model.reorderItems(oldIndex: oldIndex, newIndex: newIndex);
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
