import 'dart:async';

import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:meta/meta.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart' as test;

/// Creates a new `stateNotifier`-specific test case with the given [description].
/// [stateNotifierTest] will handle asserting that the `stateNotifier` emits the [expect]ed
/// states (in order) after [action] is executed.
/// [stateNotifierTest] also handles ensuring that no additional states are emitted
/// by closing the `stateNotifier` stream before evaluating the [expect]ation.
///
/// [setUp] is optional and should be used to set up
/// any dependencies prior to initializing the `stateNotifier` under test.
/// [setUp] should be used to set up state necessary for a particular test case.
/// For common set up code, prefer to use `setUp` from `package:test/test.dart`.
///
/// [build] should construct and return the `stateNotifier` under test.
///
/// [seed] is an optional `Function` that returns an Iterable of States
/// which will be used to seed the `stateNotifier` before [action] is called.
///
/// [action] is an optional callback which will be invoked with the `stateNotifier` under
/// test and should be used to interaction with the `stateNotifier`.
///
/// [skip] is an optional `int` which can be used to skip any number of states.
/// [skip] defaults to 0.
///
///
/// [expectInitialState] is an optional `bool`.If set to true, the initial state from the constructor will also be checked.
/// Useful when you want to validate the initial state.
/// Note: if set to `true`, it will only catch the last assigned state in the constructor.
/// [expectInitialState] defaults to `false`.
///
/// [expect] is an optional `Function` that returns a `Matcher` which the `stateNotifier`
/// under test is expected to emit after [action] is executed.
///
/// [verify] is an optional callback which is invoked after [expect]
/// and can be used for additional verification/assertions.
/// [verify] is called with the `stateNotifier` returned by [build].
///
/// [errors] is an optional `Function` that returns a `Matcher` which the `stateNotifier`
/// under test is expected to throw after [action] is executed.
///
/// [tearDown] is optional and can be used to
/// execute any code after the test has run.
/// [tearDown] should be used to clean up after a particular test case.
/// For common tear down code, prefer to use `tearDown` from `package:test/test.dart`.
///
/// ```
///
/// [stateNotifierTest] can optionally be used with one or more seeded states.
///
/// ```dart
/// stateNotifierTest(
///   'CounterNotifier emits [9,10] when seeded with 9',
///   build: () => CounterNotifier(),
///   seed: () => [9],
///   action: (stateNotifier) => stateNotifier.increment(),
///   expect: () => [9,10],
/// );
/// ```
///
/// [stateNotifierTest] can also be used to [skip] any number of emitted states
/// before asserting against the expected states.
/// [skip] defaults to 0.
///
/// ```dart
/// stateNotifierTest(
///   'CounterNotifier emits [2] when increment is called twice',
///   build: () => CounterNotifier(),
///   action: (stateNotifier) {
///     stateNotifier
///       ..increment()
///       ..increment();
///   },
///   skip: 1,
///   expect: () => [2],
/// );
/// ```
///
/// [stateNotifierTest] can also be used to [verify] internal stateNotifier functionality.
///
/// ```dart
/// stateNotifierTest(
///   'CounterNotifier emits [1] when increment is called',
///   build: () => CounterNotifier(),
///   action: (stateNotifier) => stateNotifier.increment(),
///   expect: () => [1],
///   verify: (_) {
///     verify(() => repository.someMethod(any())).called(1);
///   }
/// );
/// ```
///
/// **Note:** when using [stateNotifierTest] with state classes which don't override
/// `==` and `hashCode` you can provide an `Iterable` of matchers instead of
/// explicit state instances.
///
/// ```dart
/// stateNotifierTest(
///  'emits [StateB] when EventB is called',
///  build: () => MyBloc(),
///  action: (stateNotifier) => stateNotifier.add(EventB()),
///  expect: () => [isA<StateB>()],
/// );
/// ```
@isTest
void stateNotifierTest<SN extends StateNotifier<State>, State>(
  String description, {
  required FutureOr Function(SN stateNotifier) actions,
  FutureOr<void> Function()? setUp,
  FutureOr<void> Function(SN stateNotifier)? verify,
  FutureOr<void> Function()? tearDown,
  dynamic Function()? expect,
  Iterable<State> Function()? seed,
  int skip = 0,
  required SN Function() build,
  dynamic Function()? errors,
  bool expectInitialState = false,
}) {
  test.test(
    description,
    () async {
      await testNotifier<SN, State>(
        setUp: setUp,
        build: build,
        actions: actions,
        expect: expect,
        skip: skip,
        verify: verify,
        errors: errors,
        tearDown: tearDown,
        seed: seed,
        expectInitialState: expectInitialState,
      );
    },
  );
}

/// Internal [stateNotifierTest] runner which is only visible for testing.
/// This should never be used directly -- please use [stateNotifierTest] instead.
@visibleForTesting
Future<void> testNotifier<SN extends StateNotifier<State>, State>({
  required FutureOr Function(SN stateNotifier) actions,
  dynamic Function()? expect,
  required SN Function() build,
  Iterable<State> Function()? seed,
  FutureOr<void> Function(SN stateNotifier)? verify,
  FutureOr<void> Function()? tearDown,
  dynamic Function()? errors,
  FutureOr<void> Function()? setUp,
  required int skip,
  bool expectInitialState = false,
}) async {
  final unhandledErrors = <Object>[];

  await setUp?.call();
  List<State> states = <State>[];
  final stateNotifier = build();

  stateNotifier.addListener(
    (state) {
      states.add(state);
    },
    fireImmediately: expectInitialState,
  );

  if (seed != null) {
    final seedStates = seed.call();
    for (var state in seedStates) {
      // ignore: invalid_use_of_protected_member
      stateNotifier.state = state;
    }
  }

  try {
    await actions.call(stateNotifier);
  } catch (error) {
    if (errors == null) rethrow;
    unhandledErrors.add(error);
  }
  stateNotifier.dispose();

  states = states.skip(skip).toList();

  final expected = expect?.call();

  try {
    if (expect != null) {
      test.expect(states, test.wrapMatcher(expected));
    }
    // ignore: nullable_type_in_catch_clause
  } on test.TestFailure catch (e) {
    final diff = _diff(expected: expected, actual: states);
    final message = '${e.message}\n$diff';
    // ignore: only_throw_errors
    throw test.TestFailure(message);
  }
  await verify?.call(stateNotifier);
  await tearDown?.call();
}

String _diff({required dynamic expected, required dynamic actual}) {
  final buffer = StringBuffer();
  final differences = diff(expected.toString(), actual.toString());
  buffer
    ..writeln('${"=" * 4} diff ${"=" * 40}')
    ..writeln()
    ..writeln(differences.toPrettyString())
    ..writeln()
    ..writeln('${"=" * 4} end diff ${"=" * 36}');
  return buffer.toString();
}

extension on List<Diff> {
  String toPrettyString() {
    String identical(String str) => '\u001b[90m$str\u001B[0m';
    String deletion(String str) => '\u001b[31m[-$str-]\u001B[0m';
    String insertion(String str) => '\u001b[32m{+$str+}\u001B[0m';

    final buffer = StringBuffer();
    for (final difference in this) {
      switch (difference.operation) {
        case DIFF_EQUAL:
          buffer.write(identical(difference.text));
          break;
        case DIFF_DELETE:
          buffer.write(deletion(difference.text));
          break;
        case DIFF_INSERT:
          buffer.write(insertion(difference.text));
          break;
      }
    }
    return buffer.toString();
  }
}
