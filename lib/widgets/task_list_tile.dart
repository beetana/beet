import 'package:beet/objects/task.dart';
import 'package:beet/constants.dart';
import 'package:beet/objects/user.dart';
import 'package:flutter/material.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final Map<String, User> users;
  final double textScale;
  final Function checkboxCallback;
  final Function longPressedCallBack;
  final Function tileTappedCallback;

  TaskListTile({
    @required this.task,
    @required this.users,
    @required this.textScale,
    @required this.checkboxCallback,
    @required this.longPressedCallBack,
    @required this.tileTappedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      Container(
                        height: 24 * textScale,
                        width: 216,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: task.assignedMembersId.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 24.0 * textScale,
                              height: 24.0 * textScale,
                              child: CircleAvatar(
                                backgroundImage: users[
                                            task.assignedMembersId[index]] ==
                                        null
                                    ? const AssetImage(
                                        'images/test_user_image.png')
                                    : users[task.assignedMembersId[index]]
                                            .imageURL
                                            .isNotEmpty
                                        ? NetworkImage(
                                            users[task.assignedMembersId[index]]
                                                .imageURL,
                                          )
                                        : const AssetImage(
                                            'images/test_user_image.png'),
                                backgroundColor: Colors.transparent,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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
