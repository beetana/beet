import 'package:beet/constants.dart';
import 'package:flutter/material.dart';

class AssignTaskListTile extends StatelessWidget {
  final String userName;
  final String userImageURL;
  final bool isChecked;
  final Function tileTappedCallback;

  AssignTaskListTile(
      {this.userName,
      this.userImageURL,
      this.isChecked,
      this.tileTappedCallback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tileTappedCallback,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    child: CircleAvatar(
                      backgroundImage: userImageURL.isNotEmpty
                          ? NetworkImage(userImageURL)
                          : AssetImage('images/test_user_image.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    userName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 9.0),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 1.0,
            right: 4.0,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.check_circle,
                color: isChecked ? kPrimaryColor : kTransparentPrimaryColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
