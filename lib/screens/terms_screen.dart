import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('利用規約'),
      ),
      body: const SafeArea(
        child: WebView(
          initialUrl: 'https://beetana.github.io/beet-terms/',
        ),
      ),
    );
  }
}
