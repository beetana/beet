import 'package:beet/objects/task.dart';
import 'package:beet/utilities/constants.dart';
import 'package:beet/objects/user.dart';
import 'package:flutter/material.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final Map<String, User> users;
  final Function checkboxCallback;
  final Function longPressedCallBack;
  final Function tileTappedCallback;

  TaskListTile({
    @required this.task,
    @required this.users,
    @required this.checkboxCallback,
    @required this.longPressedCallBack,
    @required this.tileTappedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: InkWell(
        onTap: tileTappedCallback,
        onLongPress: longPressedCallBack,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: kTransparentDullWhiteColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 216,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: task.assignedMembersID.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 24.0,
                            height: 24.0,
                            child: CircleAvatar(
                              backgroundImage: users[
                                          task.assignedMembersID[index]] ==
                                      null
                                  ? AssetImage('images/test_user_image.png')
                                  : users[task.assignedMembersID[index]]
                                          .imageURL
                                          .isNotEmpty
                                      ? NetworkImage(
                                          users[task.assignedMembersID[index]]
                                              .imageURL,
                                        )
                                      : AssetImage(
                                          'images/test_user_image.png'),
                              backgroundColor: Colors.transparent,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Checkbox(
                  activeColor: kPrimaryColor,
                  value: task.isCompleted,
                  onChanged: checkboxCallback,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
