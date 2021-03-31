import 'package:beet/constants.dart';
import 'package:beet/models/use_as_guest_model.dart';
import 'package:beet/screens/use_as_guest_screen_2.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:provider/provider.dart';

class UseAsGuestScreen extends StatelessWidget {
  final songTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UseAsGuestModel>(
      create: (_) => UseAsGuestModel(),
      child: Consumer<UseAsGuestModel>(builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
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
                onPressed: () async {
                  if (model.setList.isNotEmpty) {
                    bool isBack = await _showConfirmDialog(context);
                    if (isBack) {
                      Navigator.pop(context);
                    }
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: Colors.grey[800],
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                controller: songTitleController,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'タイトル',
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                onChanged: (text) {
                                  model.title = text;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: kPrimaryColor,
                              primary: Colors.white38,
                            ),
                            child: Text(
                              '追加',
                              style: TextStyle(
                                color: kDullWhiteColor,
                                fontSize: 14.0,
                              ),
                            ),
                            onPressed: () {
                              if (model.title.isNotEmpty) {
                                model.addSong();
                                songTitleController.clear();
                              } else {
                                showMessageDialog(context, '曲のタイトルを入力してください');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  BasicDivider(),
                  Expanded(
                    child: Scrollbar(
                      child: ImplicitlyAnimatedReorderableList(
                        items: model.setList,
                        areItemsTheSame: (oldItem, newItem) =>
                            oldItem == newItem,
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
                                    item,
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
                  TextButton(
                    child: Text(
                      '次へ',
                      style: TextStyle(
                        color: model.setList.isEmpty
                            ? kInvalidEnterButtonColor
                            : kEnterButtonColor,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: model.setList.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UseAsGuestScreen2(setList: model.setList),
                              ),
                            );
                          },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

Future<bool> _showConfirmDialog(context) async {
  bool isBack;
  isBack = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('入力した内容を破棄して、最初の画面に戻ります。\nよろしいですか？'),
        actions: [
          TextButton(
            child: Text(
              'キャンセル',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: Text(
              '破棄',
              style: kDeleteButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
  return isBack;
}
