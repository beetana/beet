import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_song_details_model.dart';
import 'package:beet/screens/group_screens/group_edit_song_screen.dart';
import 'package:beet/objects/song.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSongDetailsScreen extends StatelessWidget {
  GroupSongDetailsScreen({this.groupId, this.song});
  final String groupId;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSongDetailsModel>(
      create: (_) =>
          GroupSongDetailsModel()..init(groupId: groupId, song: song),
      child: Consumer<GroupSongDetailsModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text('曲の詳細'),
                actions: [
                  TextButton(
                    child: const Text(
                      '編集',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupEditSongScreen(
                            groupId: groupId,
                            song: model.song,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                      model.startLoading();
                      try {
                        await model.getSong();
                      } catch (e) {
                        showMessageDialog(context, e.toString());
                      }
                      model.endLoading();
                    },
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 16.0),
                          const Text(
                            'タイトル',
                            style: TextStyle(
                              color: kSlightlyTransparentPrimaryColor,
                            ),
                          ),
                          Text(
                            model.songTitle,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            '演奏時間',
                            style: TextStyle(
                              color: kSlightlyTransparentPrimaryColor,
                            ),
                          ),
                          Text(
                            '${model.songPlayingTime.toString()}分',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'メモ',
                            style: TextStyle(
                              color: kSlightlyTransparentPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          BasicDivider(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: Container(
                              width: double.infinity,
                              child: Text(model.songMemo),
                            ),
                          ),
                        ),
                      ),
                    ),
                    BasicDivider(
                      indent: 16.0,
                      endIndent: 16.0,
                    ),
                    Center(
                      child: TextButton(
                        child: const Text(
                          '削除',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                        onPressed: () async {
                          bool isDelete = await _confirmDeleteDialog(
                              context, 'この曲を削除しますか？');
                          if (isDelete == true) {
                            model.startLoading();
                            try {
                              await model.deleteSong();
                              Navigator.pop(context);
                            } catch (e) {
                              showMessageDialog(context, e.toString());
                            }
                            model.endLoading();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            LoadingIndicator(isLoading: model.isLoading),
          ],
        );
      }),
    );
  }
}

Future _confirmDeleteDialog(context, message) async {
  bool _isDelete;
  _isDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text(
              'キャンセル',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text(
              '削除',
              style: kDeleteButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
  return _isDelete;
}
