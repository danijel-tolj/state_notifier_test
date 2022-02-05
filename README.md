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
