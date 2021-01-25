import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserTermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String text = '';
    return Scaffold(
      appBar: AppBar(
        title: Text('利用規約'),
      ),
      body: WebView(
        initialUrl: 'https://beetana.github.io/beet-terms/',
      ),
    );
  }
}
