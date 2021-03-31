import 'package:beet/constants.dart';
import 'package:beet/models/use_as_guest_model_2.dart';
import 'package:beet/screens/use_as_guest_screen_3.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UseAsGuestScreen2 extends StatelessWidget {
  final List<String> setList;
  final eventTitleController = TextEditingController();
  final eventPlaceController = TextEditingController();

  UseAsGuestScreen2({this.setList});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UseAsGuestModel2>(
      create: (_) => UseAsGuestModel2()..init(),
      child: Consumer<UseAsGuestModel2>(builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            if (model.isShowEventDatePicker == true) {
              model.showEventDatePicker();
            }
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('詳細'),
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: eventTitleController,
                            decoration: InputDecoration(
                              hintText: 'イベントタイトル',
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              if (model.isShowEventDatePicker == true) {
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
                            decoration: InputDecoration(
                              hintText: '会場',
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              if (model.isShowEventDatePicker == true) {
                                model.showEventDatePicker();
                              }
                            },
                            onChanged: (text) {
                              model.eventPlace = text;
                            },
                          ),
                          BasicDivider(),
                          ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 0.0),
                            title: Text(
                              '日付',
                              style: TextStyle(
                                color: kSlightlyTransparentPrimaryColor,
                              ),
                            ),
                            trailing: Text(model.eventDateText),
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              // AndroidでDatePickerを開く際にUIが崩れることがあるので少し待つ
                              // 他にいい方法があるはず
                              await Future.delayed(
                                Duration(milliseconds: 80),
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
                  Expanded(
                    child: SizedBox(),
                  ),
                  ThinDivider(),
                  TextButton(
                    child: Text(
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