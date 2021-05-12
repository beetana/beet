import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_add_song_model.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupAddSongScreen extends StatelessWidget {
  final String groupId;
  // 曲の演奏時間(分) とりあえず12分まであれば充分かと
  final List<int> songPlayingTimes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  final TextEditingController songTitleController = TextEditingController();
  final TextEditingController songMemoController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  GroupAddSongScreen({this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupAddSongModel>(
      create: (_) => GroupAddSongModel(),
      child: Consumer<GroupAddSongModel>(builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: const Text('曲を追加'),
                  actions: [
                    TextButton(
                      child: const Text(
                        '保存',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        model.startLoading();
                        try {
                          await model.addSong(groupId: groupId);
                          Navigator.pop(context);
                        } catch (e) {
                          showMessageDialog(context, e.toString());
                        }
                        model.endLoading();
                      },
                    ),
                  ],
                ),
                body: Scrollbar(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          TextField(
                            controller: songTitleController,
                            decoration: const InputDecoration(
                              hintText: 'タイトル',
                              border: InputBorder.none,
                            ),
                            onChanged: (text) {
                              model.songTitle = text;
                            },
                          ),
                          BasicDivider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  '演奏時間',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    color: kSlightlyTransparentPrimaryColor,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 72.0,
                                      width: 48.0,
                                      child: CupertinoPicker(
                                        itemExtent: 27.0,
                                        magnification: 1.2,
                                        useMagnifier: true,
                                        onSelectedItemChanged: (index) {
                                          model.songPlayingTime =
                                              songPlayingTimes[index];
                                        },
                                        children: songPlayingTimes
                                            .map(
                                              (value) => Text(
                                                '$value',
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    const Text(
                                      '分',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: kSlightlyTransparentPrimaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 36.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          BasicDivider(),
                          NotificationListener<ScrollNotification>(
                            // これをtrueにしないと親のScrollbarも同時に動いてしまう
                            onNotification: (_) => true,
                            child: Scrollbar(
                              child: TextField(
                                controller: songMemoController,
                                maxLines: 8,
                                decoration: const InputDecoration(
                                  hintText: 'メモ',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(0.0),
                                ),
                                onTap: () async {
                                  // 上手く動かないことがあるので少し待ってから
                                  // Columnの一番下までスクロールする
                                  await Future.delayed(
                                    const Duration(milliseconds: 100),
                                  );
                                  scrollController.jumpTo(
                                      scrollController.position.maxScrollExtent);
                                },
                                onChanged: (text) {
                                  model.songMemo = text;
                                },
                              ),
                            ),
                          ),
                          BasicDivider(),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              LoadingIndicator(isLoading: model.isLoading),
            ],
          ),
        );
      }),
    );
  }
}
