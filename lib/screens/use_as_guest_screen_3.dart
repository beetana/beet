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
  final List<String> setList;
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
    return ChangeNotifierProvider<UseAsGuestModel3>(
      create: (_) => UseAsGuestModel3()..init(setList: setList),
      child: Consumer<UseAsGuestModel3>(builder: (context, model, child) {
        return Scaffold(
          backgroundColor: kDullWhiteColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
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
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 16.0, right: 16.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      eventTitle,
                                      style: TextStyle(fontSize: 17.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      eventDateText,
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                    eventPlace.isNotEmpty
                                        ? Text(
                                            ' @$eventPlace',
                                            style: TextStyle(fontSize: 13.0),
                                          )
                                        : Text(''),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Expanded(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: setList.length,
                              itemExtent: 30.5,
                              itemBuilder: (context, index) {
                                return SetListTile(
                                  item: model.setList[index],
                                  songNum: model.songsNumText[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                ),
                ThinDivider(),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: TextButton(
                          child: Text(
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
                      flex: 2,
                      child: Center(
                        child: TextButton(
                          child: Text(
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
        title: Text('セットリストの画像を端末に保存して、最初の画面に戻ります。\nよろしいですか？'),
        actions: [
          TextButton(
            child: Text(
              'やり直す',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: Text(
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
