import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_in_call.g.dart';

@riverpod
class IsInCall extends _$IsInCall {
  @override
  bool build() {
    return false;
  }

  void setInCall(bool inCall) {
    state = inCall;
  }
}
