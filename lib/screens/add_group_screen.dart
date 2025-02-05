import 'package:beet/constants.dart';
import 'package:beet/screens/group_screens/group_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/dark_loading_indicator.dart';
import 'package:beet/widgets/sized_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beet/models/add_group_model.dart';

class AddGroupScreen extends StatelessWidget {
  final TextEditingController groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddGroupModel>(
      create: (_) => AddGroupModel(),
      child: WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).unfocus();
          return true;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: SizedAppBar(
              title: 'グループを作成',
            ),
            body: Consumer<AddGroupModel>(builder: (context, model, child) {
              return Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                TextField(
                                  controller: groupNameController,
                                  decoration: const InputDecoration(
                                    hintText: 'グループ名',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                                  ),
                                  onChanged: (text) {
                                    model.groupName = text;
                                  },
                                ),
                              ],
                            ),
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
                              '決定',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              model.startLoading();
                              try {
                                await model.addGroup();
                                // addGroupが完了してもgroupIdが空ということは
                                // すでに上限である8個のグループに参加している
                                if (model.groupId.isNotEmpty) {
                                  await showMessageDialog(context, '新規グループを作成しました。');
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => GroupScreen(
                                        groupId: model.groupId,
                                      ),
                                    ),
                                  );
                                } else {
                                  await showMessageDialog(context, '参加できるグループの数は8個までです。');
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                showMessageDialog(context, e.toString());
                              }
                              model.endLoading();
                            },
                          ),
                        ),
                      ],
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
