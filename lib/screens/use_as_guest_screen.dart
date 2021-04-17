import 'package:beet/constants.dart';
import 'package:beet/models/use_as_guest_model.dart';
import 'package:beet/objects/mc.dart';
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
                    model.setList.length >= 14
                        ? showMessageDialog(
                            context, '作成できるセットリストは14曲まで(MC含む)です。')
                        : model.addMC();
                  },
                ),
              ],
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await Future.delayed(
                    const Duration(milliseconds: 80),
                  );
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
                                color: kPrimaryColor,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                controller: songTitleController,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                                decoration: const InputDecoration(
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
                        const SizedBox(width: 8.0),
                        Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: kPrimaryColor,
                              primary: Colors.white38,
                            ),
                            child: const Text(
                              '追加',
                              style: TextStyle(
                                color: kDullWhiteColor,
                                fontSize: 14.0,
                              ),
                            ),
                            onPressed: () {
                              if (model.title.isNotEmpty) {
                                if (model.setList.length >= 14) {
                                  showMessageDialog(
                                      context, '作成できるセットリストは14曲まで(MC含む)です。');
                                } else {
                                  model.addSong();
                                  songTitleController.clear();
                                }
                              } else {
                                showMessageDialog(context, '曲のタイトルを入力してください。');
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
                                    item is MC ? item.title : item,
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
                            FocusScope.of(context).unfocus();
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
        title: const Text('入力した内容を破棄して、最初の画面に戻りますか？'),
        actions: [
          TextButton(
            child: const Text(
              'キャンセル',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text(
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
