import 'package:riverpod/riverpod.dart';

class ShowName extends StateNotifier<bool> {
  ShowName() : super(false);
  void changState(newState) => state = newState;
}
