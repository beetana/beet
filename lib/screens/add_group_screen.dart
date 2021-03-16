import 'package:beet/constants.dart';
import 'package:beet/screens/group_screens/group_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beet/models/add_group_model.dart';

class AddGroupScreen extends StatelessWidget {
  final groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddGroupModel>(
      create: (_) => AddGroupModel()..init(),
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
            appBar: AppBar(
              title: Text('グループを作成'),
              centerTitle: true,
            ),
            body: Consumer<AddGroupModel>(builder: (context, model, child) {
              return Stack(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: Colors.grey[800],
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                TextField(
                                  controller: groupNameController,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: 'グループ名',
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 18.0),
                                  ),
                                  onChanged: (text) {
                                    model.groupName = text;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 48.0),
                        Container(
                          height: 56.0,
                          width: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: kPrimaryColor,
                              primary: Colors.white38,
                            ),
                            child: Text(
                              '決定',
                              style: TextStyle(
                                color: Color(0xFFf5f5f5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              model.startLoading();
                              try {
                                await model.addGroup();
                                if (model.groupId.isNotEmpty) {
                                  await showMessageDialog(
                                      context, '新規グループを作成しました');
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          GroupScreen(
                                        groupId: model.groupId,
                                      ),
                                    ),
                                  );
                                } else {
                                  await showMessageDialog(
                                      context, '参加できるグループの数は8個までです');
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
                  model.isLoading
                      ? Container(
                          color: Colors.black.withOpacity(0.3),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
