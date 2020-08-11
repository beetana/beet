import 'package:beet/models/group_models/group_song_list_model.dart';
import 'package:beet/screens/group_screens/add_song_screen.dart';
import 'package:beet/screens/group_screens/set_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSongListScreen extends StatelessWidget {
  GroupSongListScreen({this.groupID});
  final String groupID;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSongListModel>(
      create: (_) => GroupSongListModel()..getSongList(groupID),
      child: Consumer<GroupSongListModel>(builder: (context, model, child) {
        return Column(
          children: <Widget>[
            FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.playlist_add,
                    color: Colors.black54,
                  ),
                  Text('セットリストを作成'),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SetListScreen(),
                  ),
                );
              },
            ),
            Flexible(
              child: ListView.builder(
                  physics: const ScrollPhysics(),
                  itemCount: model.songList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(model.songList[index].toString()),
                      onTap: () {},
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: RawMaterialButton(
                    elevation: 6.0,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    constraints: BoxConstraints.tightFor(
                      width: 56.0,
                      height: 56.0,
                    ),
                    shape: CircleBorder(),
                    fillColor: Colors.blueGrey,
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddSongScreen(groupID: groupID),
                          fullscreenDialog: true,
                        ),
                      );
                      model.getSongList(groupID);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
