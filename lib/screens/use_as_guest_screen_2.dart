import 'package:beet/constants.dart';
import 'package:beet/models/use_as_guest_model_2.dart';
import 'package:beet/objects/set_list.dart';
import 'package:beet/screens/use_as_guest_screen_3.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/sized_app_bar.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UseAsGuestScreen2 extends StatelessWidget {
  final List<SetList> setList; // setListに入るのはMCもしくはString
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController eventPlaceController = TextEditingController();

  UseAsGuestScreen2({required this.setList});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UseAsGuestModel2>(
      create: (_) => UseAsGuestModel2()..init(),
      child: Consumer<UseAsGuestModel2>(builder: (context, model, child) {
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
                  TextButton(
                    child: const Text(
                      '次へ',
                      style: TextStyle(
                        color: kEnterButtonColor,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () {
                      print(111);
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UseAsGuestScreen3(
                            setList: setList,
                            eventTitle: model.eventTitle,
                            eventPlace: model.eventPlace,
                            eventDateText: model.eventDateText,
                          ),
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
