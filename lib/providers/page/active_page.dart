import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_page.g.dart';

@riverpod
class ActivePage extends _$ActivePage {
  @override
  int build() {
    return 0;
  }

  void setActivePage(int pageId) {
    state = pageId;
  }
}
