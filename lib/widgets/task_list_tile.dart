import 'package:beet/constants.dart';
import 'package:beet/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskListTile extends StatelessWidget {
  /// 細かく分けずにTask型のままもらってきた方がいいかも
  TaskListTile({
    @required this.taskTitle,
    @required this.dueDate,
    @required this.isCompleted,
    @required this.assignedMembers,
    @required this.users,
    @required this.checkboxCallback,
    @required this.tileTappedCallback,
  });

  final String taskTitle;
  final DateTime dueDate;
  final bool isCompleted;
  final List<dynamic> assignedMembers;
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
                        itemCount: assignedMembers.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 24.0,
                            height: 24.0,
                            child: CircleAvatar(
                              backgroundImage: users[assignedMembers[index]]
                                      .imageURL
                                      .isNotEmpty
                                  ? NetworkImage(
                                      users[assignedMembers[index]].imageURL,
                                    )
                                  : AssetImage('images/test_user_image.png'),
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
