import 'package:beet/constants.dart';
import 'package:beet/models/use_as_guest_model_3.dart';
import 'package:beet/screens/welcome_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/set_list_tile.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UseAsGuestScreen3 extends StatelessWidget {
  final List<dynamic> setList;
  final String eventTitle;
  final String eventPlace;
  final String eventDateText;

  UseAsGuestScreen3({
    this.setList,
    this.eventTitle,
    this.eventPlace,
    this.eventDateText,
  });

  @override
  Widget build(BuildContext context) {
    // どんな端末を使用しても均一なセトリ画像を作るため、画面サイズを元に各サイズを指定する
    // 以下のコメントの数字はiPhoneSE 2nd換算
    final double deviceWidth = MediaQuery.of(context).size.width; // 375
    final double itemExtent = deviceWidth * 0.082; // 30.75
    final double itemTextSize = deviceWidth * 0.054; // 20.25
    final double eventTitleTextSize = deviceWidth * 0.045; // 16.875
    final double eventDetailsTextSize = deviceWidth * 0.034; // 12.75
    final double littleGap = deviceWidth * 0.021; // 7.875
    final double wideGap = deviceWidth * 0.042; // 15.75

    return ChangeNotifierProvider<UseAsGuestModel3>(
      create: (_) => UseAsGuestModel3()..init(setList: setList),
      child: Consumer<UseAsGuestModel3>(builder: (context, model, child) {
        return Scaffold(
          backgroundColor: kDullWhiteColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: AppBar(
              automaticallyImplyLeading: false,
            ),
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.0 / 1.415,
                  child: RepaintBoundary(
                    key: model.globalKey,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: wideGap, left: wideGap, right: wideGap),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      eventTitle,
                                      style: TextStyle(
                                          fontSize: eventTitleTextSize),
                                      textScaleFactor: 1.0,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      eventDateText,
                                      style: TextStyle(
                                          fontSize: eventDetailsTextSize),
                                      textScaleFactor: 1.0,
                                    ),
                                    Text(
                                      ' $eventPlace',
                                      style: TextStyle(
                                          fontSize: eventDetailsTextSize),
                                      textScaleFactor: 1.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: littleGap),
                          Expanded(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: setList.length,
                              itemExtent: itemExtent,
                              itemBuilder: (context, index) {
                                return SetListTile(
                                  item: model.setList[index],
                                  songNum: model.songsNumText[index],
                                  fontSize: itemTextSize,
                                  padding: littleGap,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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
                      child: Center(
                        child: TextButton(
                          child: const Text(
                            '戻る',
                            style: TextStyle(
                              color: kSlightlyTransparentPrimaryColor,
                              fontSize: 16.0,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: TextButton(
                          child: const Text(
                            '保存',
                            style: TextStyle(
                              color: kEnterButtonColor,
                              fontSize: 16.0,
                            ),
                          ),
                          onPressed: () async {
                            bool isSave = await _showConfirmDialog(context);
                            if (isSave) {
                              await model.saveSetListImage();
                              await showMessageDialog(context, '保存しました');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      WelcomeScreen(),
                                ),
                              );
                            }
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

Future<bool> _showConfirmDialog(context) async {
  bool isSave;
  isSave = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('セットリストの画像を保存して、最初の画面に戻りますか？'),
        actions: [
          TextButton(
            child: const Text(
              'やり直す',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text(
              '保存',
              style: kEnterButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
  return isSave;
}
