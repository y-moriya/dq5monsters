import 'package:riverpod/riverpod.dart';

class ImageSize extends StateNotifier<double> {
  ImageSize() : super(100.0);
  void changState(newState) => this.state = newState;
}
