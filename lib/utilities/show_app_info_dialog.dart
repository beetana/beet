import 'package:beet/constants.dart';
import 'package:flutter/material.dart';

Future showAppInfoDialog(context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('images/app_icon.png'),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'beet',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  '1.0.0',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  '2021  Kohei Tanabe',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              '閉じる',
              style: kEnterButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              'ライセンスを表示',
              style: kEnterButtonTextStyle,
            ),
            onPressed: () {
              showLicensePage(context: context);
            },
          ),
        ],
      );
    },
  );
}
