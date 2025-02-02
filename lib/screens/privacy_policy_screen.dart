import 'package:beet/widgets/sized_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final webViewController = WebViewController()..loadRequest(Uri.parse('https://beetana.github.io/beet-privacy-policy/'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SizedAppBar(
        title: 'プライバシーポリシー',
      ),
      body: SafeArea(
        child: WebViewWidget(controller: webViewController),
      ),
    );
  }
}
