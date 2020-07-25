import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'メールアドレス',
              ),
              onChanged: (String text) {},
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'パスワード',
              ),
              onChanged: (String text) {},
            ),
            SizedBox(
              height: 24.0,
            ),
            RaisedButton(
              elevation: 3.0,
              child: Text("ログイン"),
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              onPressed: () {},
            ),
            RaisedButton(
              elevation: 3.0,
              child: Text("新規登録"),
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
