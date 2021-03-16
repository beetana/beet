import 'package:beet/utilities/constants.dart';
import 'package:beet/models/drawer_model.dart';
import 'package:beet/screens/add_group_screen.dart';
import 'package:beet/screens/group_screens/group_screen.dart';
import 'package:beet/screens/user_screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DrawerModel>(
      create: (_) => DrawerModel()..init(),
      child: Consumer<DrawerModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Drawer(
              child: Column(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(model.userName),
                    accountEmail: Text(''),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: model.userImageURL.isNotEmpty
                          ? NetworkImage(model.userImageURL)
                          : AssetImage('images/test_user_image.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'マイページ',
                      style: TextStyle(
                        color: kPrimaryColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserScreen(userId: model.userId),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        itemCount: model.groupsName.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              model.groupsName[index],
                              style: TextStyle(
                                color: kPrimaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupScreen(
                                    groupId: model.groupsId[index],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.add,
                        color: kSlightlyTransparentPrimaryColor,
                      ),
                      label: Text(
                        'グループを作成',
                        style: TextStyle(
                          color: kSlightlyTransparentPrimaryColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddGroupScreen(),
                            fullscreenDialog: true,
                          ),
                        );
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
    );
  }
}
