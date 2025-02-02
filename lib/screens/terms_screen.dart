import 'package:beet/widgets/sized_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsScreen extends StatelessWidget {
  final webViewController = WebViewController()..loadRequest(Uri.parse('https://beetana.github.io/beet-terms/'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SizedAppBar(
        title: '利用規約',
      ),
      body: SafeArea(
        child: WebViewWidget(controller: webViewController),
      ),
    );
  }
}
