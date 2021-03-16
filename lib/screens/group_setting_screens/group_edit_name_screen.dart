import 'package:beet/models/group_setting_models/group_edit_name_model.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupEditNameScreen extends StatelessWidget {
  GroupEditNameScreen({this.groupId, this.groupName});
  final String groupId;
  final String groupName;
  final groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    groupNameController.text = groupName;
    return ChangeNotifierProvider<GroupEditNameModel>(
      create: (_) =>
          GroupEditNameModel()..init(groupId: groupId, groupName: groupName),
      child: Consumer<GroupEditNameModel>(builder: (context, model, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text('グループ名を変更'),
                  actions: [
                    TextButton(
                      child: Text(
                        '保存',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        model.startLoading();
                        try {
                          await model.updateGroupName();
                          Navigator.pop(context);
                        } catch (e) {
                          await showMessageDialog(context, e.toString());
                        }
                        model.endLoading();
                      },
                    )
                  ],
                ),
                body: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: groupNameController,
                    decoration: InputDecoration(
                      hintText: 'グループ名',
                      suffix: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          groupNameController.clear();
                          model.groupName = '';
                        },
                      ),
                    ),
                    onChanged: (text) {
                      model.groupName = text;
                    },
                  ),
                ),
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
    );
  }
}
