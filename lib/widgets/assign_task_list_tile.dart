import 'package:beet/constants.dart';
import 'package:flutter/material.dart';

class AssignTaskListTile extends StatelessWidget {
  final String userName;
  final String userImageURL;
  final bool isChecked;
  final Function checkboxCallback;
  final Function tileTappedCallback;

  AssignTaskListTile(
      {this.userName,
      this.userImageURL,
      this.isChecked,
      this.checkboxCallback,
      this.tileTappedCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: userImageURL.isNotEmpty
            ? NetworkImage(userImageURL)
            : AssetImage('images/test_user_image.png'),
        backgroundColor: Colors.transparent,
      ),
      title: Text(
        userName,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Checkbox(
        activeColor: kPrimaryColor,
        value: isChecked,
        onChanged: checkboxCallback,
      ),
      onTap: tileTappedCallback,
    );
  }
}
