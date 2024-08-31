import 'package:beet/objects/set_list.dart';

/// '-MC-'というただの文字列だと、keyにしたときに判別できないのでクラスとして作成した

class GuestModeSong implements SetList {
  @override
  final String title;

  GuestModeSong(this.title);
}
