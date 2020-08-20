import 'package:beet/models/group_models/group_main_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupMainScreen extends StatelessWidget {
  final dateFormat = DateFormat("y.M.d");
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupMainModel>(
      create: (_) => GroupMainModel(),
      child: Consumer<GroupMainModel>(builder: (context, model, child) {
        return Column(
          children: <Widget>[
            Text(
              dateFormat.format(DateTime.now()),
              style: TextStyle(fontSize: 30.0),
            ),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.only(
                    top: 32.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  itemCount: model.schedules.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Material(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        textStyle: TextStyle(
                          fontSize: 30.0,
                        ),
                        color: Colors.grey,
                        child: Center(
                            child: Text('sample ${model.schedules[index]}')),
                      ),
                    );
                  }),
            ),
          ],
        );
      }),
    );
  }
}
