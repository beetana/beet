import 'package:beet/utilities/constants.dart';
import 'package:beet/objects/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskListTile extends StatelessWidget {
  /// 細かく分けずにTask型のままもらってきた方がいいかも
  TaskListTile({
    @required this.taskTitle,
    @required this.dueDate,
    @required this.isCompleted,
    @required this.assignedMembersID,
    @required this.users,
    @required this.checkboxCallback,
    @required this.tileTappedCallback,
  });

  final String taskTitle;
  final DateTime dueDate;
  final bool isCompleted;
  final List<dynamic> assignedMembersID;
  final Map<String, User> users;
  final Function checkboxCallback;
  final Function tileTappedCallback;
  final DateFormat dateFormat = DateFormat('M/d');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: InkWell(
        onTap: tileTappedCallback,
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
                      taskTitle,
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
                        itemCount: assignedMembersID.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 24.0,
                            height: 24.0,
                            child: CircleAvatar(
                              backgroundImage:
                                  users[assignedMembersID[index]] == null
                                      ? AssetImage('images/test_user_image.png')
                                      : users[assignedMembersID[index]]
                                              .imageURL
                                              .isNotEmpty
                                          ? NetworkImage(
                                              users[assignedMembersID[index]]
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
                  value: isCompleted,
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
