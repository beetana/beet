import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_set_list_model_2.dart';
import 'package:beet/objects/set_list.dart';
import 'package:beet/screens/group_screens/group_set_list_screen_3.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/sized_app_bar.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSetListScreen2 extends StatelessWidget {
  final List<SetList> setList; // setListに入るのはSongもしくはMC
  final int songCount;
  final int totalPlayTime;
  final String groupId;
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController eventPlaceController = TextEditingController();

  GroupSetListScreen2({
    required this.setList,
    required this.songCount,
    required this.totalPlayTime,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSetListModel2>(
      create: (_) => GroupSetListModel2()..init(),
      child: Consumer<GroupSetListModel2>(builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            if (model.isShowEventDatePicker) {
              model.showEventDatePicker();
            }
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: SizedAppBar(
              title: '詳細',
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: eventTitleController,
                            decoration: const InputDecoration(
                              hintText: 'イベントタイトル',
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              if (model.isShowEventDatePicker) {
                                model.showEventDatePicker();
                              }
                            },
                            onChanged: (text) {
                              model.eventTitle = text;
                            },
                          ),
                          BasicDivider(),
                          TextField(
                            controller: eventPlaceController,
                            decoration: const InputDecoration(
                              hintText: '会場',
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              if (model.isShowEventDatePicker) {
                                model.showEventDatePicker();
                              }
                            },
                            onChanged: (text) {
                              model.eventPlace = text;
                            },
                          ),
                          BasicDivider(),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                            title: const Text(
                              '日付',
                              style: TextStyle(
                                color: kSlightlyTransparentPrimaryColor,
                              ),
                            ),
                            trailing: Text(model.eventDateText),
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              // AndroidでDatePickerを開く際にUIが崩れることがあるので少し待つ
                              await Future.delayed(
                                const Duration(milliseconds: 80),
                              );
                              model.showEventDatePicker();
                            },
                          ),
                          model.eventDatePickerBox,
                          BasicDivider(),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  ThinDivider(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text('$songCount 曲'),
                            Text('$totalPlayTime 分'),
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
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupSetListScreen3(
                                    setList: setList,
                                    eventTitle: model.eventTitle,
                                    eventPlace: model.eventPlace,
                                    eventDateText: model.eventDateText,
                                    songCount: songCount,
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
          ),
        );
      }),
    );
  }
}
