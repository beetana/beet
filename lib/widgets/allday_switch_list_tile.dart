import 'package:beet/constants.dart';
import 'package:flutter/material.dart';

class AlldaySwitchListTile extends StatelessWidget {
  final bool value;
  final Function onChanged;

  AlldaySwitchListTile({this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('終日'),
      trailing: Switch(
        value: value,
        activeColor: kDullWhiteColor,
        activeTrackColor: kDullGreenColor,
        inactiveTrackColor: kTransparentPrimaryColor,
        onChanged: onChanged,
      ),
    );
  }
}
