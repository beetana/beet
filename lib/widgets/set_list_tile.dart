import 'package:flutter/material.dart';

class SetListTile extends StatelessWidget {
  final List<String> setList;
  final int index;

  SetListTile({
    this.setList,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    List<String> songNum = [];
    List<String> mcCount = [];
    String numText;
    for (int i = 0; i < setList.length; i++) {
      if (setList[i].startsWith('-MC')) {
        songNum.add('    ');
        mcCount.add('MC');
      } else {
        var num = songNum.length - mcCount.length + 1;
        if (num < 10) {
          numText = ' ${num.toString()}.';
        } else {
          numText = '${num.toString()}.';
        }
        songNum.add(numText);
      }
    }
    return ListTile(
      title: Text(
        '${songNum[index]} ${setList[index]}',
        style: TextStyle(fontSize: 20.0),
        maxLines: 1,
      ),
      onTap: () {},
    );
  }
}
