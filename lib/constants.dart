import 'package:flutter/material.dart';

/// primaryColorの候補
// 0xFF0B5DA3
// 0xFF2D3146
// 0xFF415C59
// 0xFF135589
// 0xFF46494E

const Color kPrimaryColor = Color(0xFF424242);
const Color kSlightlyTransparentPrimaryColor = Color(0xCC424242);
const Color kTransparentPrimaryColor = Color(0x55424242);
const Color kBackGroundColor = Color(0xFFFFFFFF);
const Color kDullGreenColor = Color(0xFF415C59);
const Color kDullWhiteColor = Color(0xFFF5F5F5);
const Color kTransparentDullWhiteColor = Color(0x55E5E5E5);
const Color kEnterButtonColor = Color(0xFF448AFF);
const Color kInvalidEnterButtonColor = Color(0x55448AFF);
const TextStyle kEnterButtonTextStyle = TextStyle(color: Colors.blueAccent);
const TextStyle kDeleteButtonTextStyle = TextStyle(color: Colors.redAccent);
const TextStyle kCancelButtonTextStyle = TextStyle(color: Colors.black54);
const bool kFirebaseEnvironment = bool.fromEnvironment('dart.vm.product');
