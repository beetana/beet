import 'package:beet/constants.dart';
import 'package:beet/services/dynamic_links_services.dart';
import 'package:beet/models/group_setting_models/group_member_model.dart';
import 'package:beet/screens/user_screens/user_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GroupMemberScreen extends StatelessWidget {
  GroupMemberScreen({this.groupId});
  final groupId;
  final dynamicLinks = DynamicLinksServices();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupMemberModel>(
      create: (_) => GroupMemberModel()..init(groupId: groupId),
      child: Consumer<GroupMemberModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text('メンバー'),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: const ScrollPhysics(),
                        itemCount: model.usersName.length,
                        itemBuilder: (BuildContext context, int index) {
                          String userId = model.usersId[index];
                          String userName = model.usersName[index];
                          String userImageURL = model.usersImageURL[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: userImageURL.isNotEmpty
                                  ? NetworkImage(userImageURL)
                                  : const AssetImage('images/user_profile.png'),
                              backgroundColor: Colors.transparent,
                            ),
                            title: Text(
                              userName,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () async {
                              bool isMe = userId == model.myId;
                              bool isDelete = await _showMemberBottomSheet(
                                context,
                                isMe,
                                userName,
                              );
                              if (isDelete == true) {
                                model.startLoading();
                                try {
                                  if (isMe == true) {
                                    final memberCount =
                                        await model.checkMemberCount();
                                    memberCount == 1
                                        ? await model.deleteGroup(
                                            userId: userId)
                                        : await model.deleteMember(
                                            userId: userId);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            UserScreen(),
                                      ),
                                    );
                                  } else {
                                    await model.deleteMember(userId: userId);
                                    await model.fetchMembers();
                                  }
                                } catch (e) {
                                  showMessageDialog(context, e.toString());
                                }
                                model.endLoading();
                              }
                            },
                          );
                        },
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(
                        Icons.group_add,
                        color: kSlightlyTransparentPrimaryColor,
                      ),
                      label: const Text(
                        'メンバーを招待',
                        style: TextStyle(
                          color: kSlightlyTransparentPrimaryColor,
                        ),
                      ),
                      onPressed: () async {
                        model.startLoading();
                        Uri link = await dynamicLinks.createDynamicLink(
                          groupId: groupId,
                          groupName: model.groupName,
                        );
                        model.endLoading();
                        await _inviteMemberDialog(
                            context, link, model.groupName);
                      },
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

Future<bool> _showMemberBottomSheet(
    BuildContext context, bool isMe, String userName) async {
  String buttonText = isMe ? 'グループを退会' : 'このメンバーを削除';
  bool isDelete;
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          color: const Color(0xFF757575),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    userName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () async {
                      isDelete =
                          await _showConfirmDialog(context, isMe, userName);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
  return isDelete;
}

Future<bool> _showConfirmDialog(context, isMe, userName) async {
  String titleText = isMe ? 'グループを退会しますか?' : '$userNameをグループから削除しますか?';
  String buttonText = isMe ? '退会' : '削除';
  bool isDelete;
  isDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titleText),
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
            child: Text(
              buttonText,
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
  return isDelete;
}

Future _inviteMemberDialog(context, dynamicLink, groupName) async {
  final String inviteMessage =
      'beetのグループ「$groupName」への招待が届きました。\n招待リンクをタップしてグループに参加しましょう。\n▶︎まずはbeetをダウンロード\niOS\niOSリンク\nAndroid\nAndroidリンク\n▶︎アプリにログイン後、以下の招待リンクをタップ\n$dynamicLink';
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        title: const Text('次のメッセージをシェアしてグループに参加してもらいましょう。'),
        titleTextStyle: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        titlePadding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        children: [
          SimpleDialogOption(
            child: Text(
              inviteMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8.0),
          SimpleDialogOption(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2.0,
                  color: kEnterButtonColor,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                  child: Text(
                'メッセージをコピー',
                style: TextStyle(color: kEnterButtonColor),
              )),
            ),
            onPressed: () async {
              final ClipboardData data = ClipboardData(text: inviteMessage);
              await Clipboard.setData(data);
              await showMessageDialog(context, 'コピーしました。');
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}
