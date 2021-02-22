import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserPrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('プライバシーポリシー'),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://beetana.github.io/beet-privacy-policy/',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
