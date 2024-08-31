import 'package:beet/constants.dart';
import 'package:flutter/material.dart';

class AlldaySwitchListTile extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  AlldaySwitchListTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('終日'),
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
