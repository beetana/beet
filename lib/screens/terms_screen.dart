import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsScreen extends StatelessWidget {
  final webViewController = WebViewController()..loadRequest(Uri.parse('https://beetana.github.io/beet-terms/'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('利用規約'),
      ),
      body: SafeArea(
        child: WebViewWidget(controller: webViewController),
      ),
    );
  }
}
