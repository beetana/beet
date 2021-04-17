import 'package:beet/constants.dart';
import 'package:beet/widgets/manual_list_tile.dart';
import 'package:flutter/material.dart';

class ManualScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDullWhiteColor,
      appBar: AppBar(
        title: const Text('アプリの使い方'),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            physics: const ScrollPhysics(),
            children: <Widget>[
              ManualListTile(
                question: '作成中のセットリストから曲を削除したい',
                answer: 'セットリストの並べ替え画面で、曲やMCを長押しすることで削除できます。',
              ),
              ManualListTile(
                question: '追加した予定が表示されない',
                answer: 'イベント一覧やタスク一覧は、画面を上から下にスワイプすることで更新できます。',
              ),
              ManualListTile(
                question: '完了したタスクを完了フォルダに移したい',
                answer:
                    'タスク右端のチェックボックスにチェックを入れ、更新ボタンを押すと完了フォルダに移動します。同様に、完了フォルダから未完了フォルダに移動させることもできます。\nまた、タスクを削除する際はタスクを長押しすることで簡単に削除できます。',
              ),
              ManualListTile(
                question: 'グループを作りたい',
                answer:
                    '新規グループ作成の手順は以下の通りです。\n1.画面左上のメニューバーからメニューを開き、一番下の[グループを作成]をタップ。\n2.グループ名を入力し、決定ボタンをタップ。',
              ),
              ManualListTile(
                question: 'グループにメンバーを招待したい',
                answer:
                    'メンバー招待の手順は以下の通りです。\n1.招待したいグループの画面を開く。\n2.右上の歯車アイコンから設定を開き、[メンバー]をタップ。\n3.一番下の[メンバーを招待]をタップ。\n4.招待メッセージが表示されるので、コピーして招待したい人に共有しましょう。',
              ),
              ManualListTile(
                question: 'グループを削除したい',
                answer:
                    '直接グループを削除する機能はありませんが、グループを退会することができます。\nグループのメンバーが1人もいなくなった時点で、そのグループのデータは全て削除されます。\nグループを退会する手順は以下の通りです。\n1.退会したいグループの画面を開く。\n2.右上の歯車アイコンから設定を開き、[メンバー]をタップ。\n3.退会するアカウントの名前をタップ。\n4.[グループを退会]をタップ。',
              ),
              ManualListTile(
                question: 'パスワードを忘れた',
                answer: 'ログイン画面の[パスワードを忘れた場合]からパスワードの再設定を行ってください。',
              ),
              ManualListTile(
                question: 'アカウントを削除してアプリを退会したい',
                answer:
                    'アカウント削除の手順は以下の通りです。\n1.マイページを開く。\n2.右上の歯車アイコンから設定を開き、[アカウント情報]をタップ。\n3.一番下の[アカウントを削除]をタップ。\n4.パスワードを入力し、[アカウントを削除]をタップ。',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
