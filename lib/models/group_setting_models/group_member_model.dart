import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class GroupMemberModel extends ChangeNotifier {
  String groupID;
  String groupName;
  Uri dynamicLink;
  bool isLoading = false;

  void init({groupID, groupName}) {
    this.groupID = groupID;
    this.groupName = groupName;
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
      uriPrefix: 'https://beetana.page.link',
      link: Uri.parse('https://beetana.page.link/?id=$groupID&name=$groupName'),
      androidParameters: AndroidParameters(
        packageName: 'com.beetana.beet',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.beetana.beet',
        minimumVersion: '1',
        fallbackUrl:
            Uri.parse('https://apps.apple.com/jp/app/memow/id1518582060'),
      ),
    );

    Uri link = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink =
        await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    dynamicLink = shortenedLink.shortUrl;
    print('$dynamicLink');
    print('$dynamicLink?d=1');
  }
}
