import 'package:state_notifier/state_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:state_notifier_test/state_notifier_test.dart';
import 'package:test/test.dart';

// Mock StateNotifier
class MockCounterStateNotifier extends Mock implements CounterStateNotifier {}

void main() {
  group('CounterStateNotifier', () {
    stateNotifierTest<CounterStateNotifier, int>(
      'emits [] when nothing is added',
      actions: (_) {},
      build: () => CounterStateNotifier(),
      expect: () => const <int>[],
    );

    stateNotifierTest<CounterStateNotifier, int>(
      'emits [1] when increment is called',
      build: () => CounterStateNotifier(),
      actions: (CounterStateNotifier notifier) => notifier.increment(),
      expect: () => const <int>[1],
    );
  });
}

class CounterStateNotifier extends StateNotifier<int> {
  CounterStateNotifier() : super(0);

  void increment() {
    state = state + 1;
  }
}
