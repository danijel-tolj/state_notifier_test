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

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Testing Options
 `setUp` is optional and should be used to set up
 any dependencies prior to initializing the `stateNotifier` under test.
 `setUp` should be used to set up state necessary for a particular test case.
 For common set up code, prefer to use `setUp` from `package:test/test.dart`.

 `build` should construct and return the `stateNotifier` under test.

 `seed` is an optional `Function` that returns a state
 which will be used to seed the `stateNotifier` before `action` is called.

 `action` is an optional callback which will be invoked with the `stateNotifier` under
 test and should be used to interaction with the `stateNotifier`.

 `skip` is an optional `int` which can be used to skip any number of states.
 `skip` defaults to 0.

 `expect` is an optional `Function` that returns a `Matcher` which the `stateNotifier`
 under test is expected to emit after `action` is executed.

 `verify` is an optional callback which is invoked after `expect`
 and can be used for additional verification/assertions.
 `verify` is called with the `stateNotifier` returned by `build`.

 `errors` is an optional `Function` that returns a `Matcher` which the `stateNotifier`
 under test is expected to throw after `action` is executed.

 `tearDown` is optional and can be used to
 execute any code after the test has run.
 `tearDown` should be used to clean up after a particular test case.
 For common tear down code, prefer to use `tearDown` from `package:test/test.dart`.


## Usage

```dart
stateNotifierTest(
  'CounterNotifier emits [10] when seeded with 9',
  build: () => CounterNotifier(),
  seed: () => 9,
  action: (stateNotifier) => stateNotifier.increment(),
  expect: () => [10],
);
```

`stateNotifierTest` can also be used to `skip` any number of emitted states
before asserting against the expected states.
`skip` defaults to 0.

```dart
stateNotifierTest(
  'CounterNotifier emits [2] when increment is called twice',
  build: () => CounterNotifier(),
  action: (stateNotifier) {
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
  action: (stateNotifier) => stateNotifier.increment(),
  expect: () => [1],
  verify: (_) {
    verify(() => repository.someMethod(any())).called(1);
  }
);
 ```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
