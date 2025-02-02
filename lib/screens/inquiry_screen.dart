import 'package:beet/constants.dart';
import 'package:beet/models/inquiry_model.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/dark_loading_indicator.dart';
import 'package:beet/widgets/sized_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InquiryScreen extends StatelessWidget {
  final TextEditingController contentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InquiryModel>(
      create: (_) => InquiryModel(),
      child: WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).unfocus();
          // キーボードを完全に閉じてから戻らないとUIが崩れることがあるので少し待つ
          await Future.delayed(
            const Duration(milliseconds: 80),
          );
          return true;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: SizedAppBar(
              title: 'ご意見・お問い合わせ',
            ),
            body: Consumer<InquiryModel>(builder: (context, model, child) {
              return Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 32.0),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: kPrimaryColor,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextField(
                              controller: contentTextController,
                              maxLines: 6,
                              decoration: const InputDecoration(
                                hintText: '追加してほしい機能・改善してほしい点・その他お問い合わせなど',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16.0),
                              ),
                              onChanged: (text) {
                                model.inquiryContent = text;
                              },
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          Container(
                            height: 56.0,
                            width: 160.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white38,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: kPrimaryColor,
                              ),
                              child: const Text(
                                '送信',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                model.startLoading();
                                try {
                                  await model.submitInquiry();
                                  FocusScope.of(context).unfocus();
                                  await showMessageDialog(context, '送信しました。');
                                  Navigator.pop(context);
                                } catch (e) {
                                  showMessageDialog(context, e.toString());
                                }
                                model.endLoading();
                              },
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            '頂いたご意見への個別の回答は行っておりません。\nトラブルやお困りごとなど、返信が必要な場合は\nメールアドレスも記入してお送りください。',
                            style: TextStyle(fontSize: 14.0),
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.0,
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                  DarkLoadingIndicator(isLoading: model.isLoading),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
