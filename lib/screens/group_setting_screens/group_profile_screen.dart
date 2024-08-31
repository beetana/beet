import 'package:beet/constants.dart';
import 'package:beet/models/group_setting_models/group_profile_model.dart';
import 'package:beet/screens/group_setting_screens/group_edit_name_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupProfileScreen extends StatelessWidget {
  final String groupId;

  GroupProfileScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupProfileModel>(
      create: (_) => GroupProfileModel()..init(groupId: groupId),
      child: Consumer<GroupProfileModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text('グループ情報'),
              ),
              body: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: kDullWhiteColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 112.0,
                              height: 112.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: kPrimaryColor,
                                  width: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: InkWell(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: model.imageFile != null
                                      ? Image.file(model.imageFile!)
                                      : model.groupImageURL.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: '${model.groupImageURL}',
                                              placeholder: (context, url) =>
                                                  Container(color: kDullWhiteColor),
                                              errorWidget: (context, url, error) =>
                                                  Container(color: kDullWhiteColor),
                                            )
                                          : Image.asset('images/group_profile.png'),
                                ),
                                onTap: () async {
                                  ChangeImage changeImage =
                                      await _showEditIconBottomSheet(context);
                                  if (changeImage == ChangeImage.delete) {
                                    model.startLoading();
                                    try {
                                      await model.deleteGroupImage();
                                    } catch (e) {
                                      await showMessageDialog(
                                          context, e.toString());
                                    }
                                    model.endLoading();
                                  } else if (changeImage == ChangeImage.select) {
                                    await model.pickImageFile();
                                    if (model.imageFile != null) {
                                      model.startLoading();
                                      try {
                                        await model.updateGroupImage();
                                      } catch (e) {
                                        await showMessageDialog(
                                            context, e.toString());
                                      }
                                      model.endLoading();
                                    }
                                  }
                                },
                              ),
                            ),
                            Positioned(
                              child: CircleAvatar(
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                    size: 16.0,
                                  ),
                                  onPressed: () async {
                                    ChangeImage changeImage =
                                        await _showEditIconBottomSheet(context);
                                    if (changeImage == ChangeImage.delete) {
                                      model.startLoading();
                                      try {
                                        await model.deleteGroupImage();
                                      } catch (e) {
                                        await showMessageDialog(
                                            context, e.toString());
                                      }
                                      model.endLoading();
                                    } else if (changeImage == ChangeImage.select) {
                                      await model.pickImageFile();
                                      if (model.imageFile != null) {
                                        model.startLoading();
                                        try {
                                          await model.updateGroupImage();
                                        } catch (e) {
                                          await showMessageDialog(
                                              context, e.toString());
                                        }
                                        model.endLoading();
                                      }
                                    }
                                  },
                                ),
                                backgroundColor: Colors.black45,
                                radius: 16.0,
                              ),
                              bottom: 0.0,
                              right: 0.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('グループ名'),
                    subtitle: Text(
                      model.groupName,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupEditNameScreen(
                            groupId: groupId,
                            groupName: model.groupName,
                          ),
                        ),
                      );
                      model.init(groupId: groupId);
                    },
                  ),
                  Expanded(
                    child: Container(
                      color: kDullWhiteColor,
                    ),
                  ),
                ],
              ),
            ),
            LoadingIndicator(isLoading: model.isLoading),
          ],
        );
      }),
    );
  }
}

enum ChangeImage {
  select,
  delete,
  cancel,
}

Future<ChangeImage> _showEditIconBottomSheet(BuildContext context) async {
  ChangeImage changeImage = ChangeImage.cancel;
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          color: const Color(0xFF757575),
          child: Container(
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
                  TextButton(
                    child: const Text(
                      'ライブラリから選択',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 17.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: () async {
                      changeImage = ChangeImage.select;
                      Navigator.pop(context);
                    },
                  ),
                  BasicDivider(),
                  TextButton(
                    child: const Text(
                      '写真を削除',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 17.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: () async {
                      bool isDelete = await _showConfirmDialog(context);
                      isDelete
                          ? changeImage = ChangeImage.delete
                          : changeImage = ChangeImage.cancel;
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
  return changeImage;
}

Future<bool> _showConfirmDialog(context) async {
  bool isDelete;
  isDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('プロフィール画像を削除しますか?'),
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
  return isDelete;
}
