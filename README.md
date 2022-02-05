<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

## Package

Package is a port of `felangel`'s `bloc_test`, modified to work with StateNotifier class

## Installation

Add to dev dependencies inside pubspec_yaml:

```yaml
    dev_dependencies:
        state_notifier_test: [version]
```

## Usage

```dart
import 'package:state_notifier_test.dart';

stateNotifierTest(
  'CounterNotifier emits [10] when seeded with 9',
  build: () => CounterNotifier(),
  seed: () => 9,
  actions: (stateNotifier) => stateNotifier.increment(),
  expect: () => [10],
);

class CounterStateNotifier extends StateNotifier<int> {
  CounterStateNotifier() : super(0);

  void increment() {
    state = state + 1;
  }
}
```

`stateNotifierTest` can also be used to `skip` any number of emitted states
before asserting against the expected states.
`skip` defaults to 0.

```dart
stateNotifierTest(
  'CounterNotifier emits [2] when increment is called twice',
  build: () => CounterNotifier(),
  actions: (stateNotifier) {
    stateNotifier
      ..increment()
      ..increment();
  },
  skip: 1,
  expect: () => [2],
);
```

`stateNotifierTest` can also be used to `verify` internal stateNotifier functionality.

```dart
stateNotifierTest(
  'CounterNotifier emits [1] when increment is called',
  build: () => CounterNotifier(),
  actions: (stateNotifier) => stateNotifier.increment(),
  expect: () => [1],
  verify: (_) {
    verify(() => repository.someMethod(any())).called(1);
  }
);
 ```


## Testing Options
 `setUp` is optional and should be used to set up
 any dependencies prior to initializing the `stateNotifier` under test.
 `setUp` should be used to set up state necessary for a particular test case.
 For common set up code, prefer to use `setUp` from `package:test/test.dart`.

 `build` should construct and return the `stateNotifier` under test.

 `seed` is an optional `Function` that returns a state
 which will be used to seed the `stateNotifier` before `actions` is called.

 `actions` is an optional callback which will be invoked with the `stateNotifier` under
 test and should be used to interactions with the `stateNotifier`.

 `skip` is an optional `int` which can be used to skip any number of states.
 `skip` defaults to 0.

 `expect` is an optional `Function` that returns a `Matcher` which the `stateNotifier`
 under test is expected to emit after `actions` is executed.

 `verify` is an optional callback which is invoked after `expect`
 and can be used for additional verification/assertions.
 `verify` is called with the `stateNotifier` returned by `build`.

 `errors` is an optional `Function` that returns a `Matcher` which the `stateNotifier`
 under test is expected to throw after `actions` is executed.

 `tearDown` is optional and can be used to
 execute any code after the test has run.
 `tearDown` should be used to clean up after a particular test case.
 For common tear down code, prefer to use `tearDown` from `package:test/test.dart`.

