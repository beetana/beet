import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class GroupMemberModel extends ChangeNotifier {
  String groupID;
  bool isLoading = false;

  void init({groupID}) {
    this.groupID = groupID;
    notifyListeners();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future createDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://beet.page.link',
      link: Uri.parse('https://beet.page.link/?id=$groupID'),
      androidParameters: AndroidParameters(
        packageName: 'com.beetana.beet',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.beetana.beet',
        minimumVersion: '1',
      ),
    );

    Uri dynamicUrl = await parameters.buildUrl();
    print(dynamicUrl);

//    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
//    final Uri shortUrl = shortDynamicLink.shortUrl;
//    print(shortUrl);
  }
}
