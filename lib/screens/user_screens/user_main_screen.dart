import 'package:beet/models/user_models/user_main_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserMainModel>(
      create: (_) => UserMainModel(),
      child: Consumer<UserMainModel>(builder: (context, model, child) {
        return ListView.builder(
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
                  child:
                      Center(child: Text('sample ${model.schedules[index]}')),
                ),
              );
            });
      }),
    );
  }
}
