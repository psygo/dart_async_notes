# Dart Async Notes

## Resources

| Index | Article                                                                       | Domain                           |
| ----- | ----------------------------------------------------------------------------- | -------------------------------- |
| 1     | [Asynchronous programming: futures, async, await][dart.dev_async]             | [dart.dev][dart.dev]             |
| 2     | [Dart Microtasks Example][microtask_example]                                  | [jpryan.me][jpryan]              |
| 3     | [Flutter execute code with MicroTask queue and Event queue][devexps_medium_1] | [devexps Medium][devexps_medium] |


[dart.dev]: https://dart.dev/
[dart.dev_async]: https://dart.dev/codelabs/async-await#why-asynchronous-code-matters
[devexps_medium]: https://medium.com/@devexps/
[devexps_medium_1]: https://medium.com/@devexps/flutter-execute-code-with-microtask-queue-and-event-queue-f2dc10b06aad
[jpryan]: http://jpryan.me/
[microtask_example]: http://jpryan.me/dartbyexample/examples/microtasks/

## Articles

### [Asynchronous programming: futures, async, await][dart.dev_async]

**Key terms:**

- **synchronous operation**: A synchronous operation blocks other operations from executing until it completes.
- **synchronous function**: A synchronous function only performs synchronous operations.
- **asynchronous operation**: Once initiated, an asynchronous operation allows other operations to execute before it completes.
- **asynchronous function**: An asynchronous function performs at least one asynchronous operation and can also perform *synchronous* operations.

*This explanation is wrong*:

> In the preceding example, even though `fetchUserOrder()` executes before the `print()` call on line 8, the console shows the output from line 8 (“Fetching user order…”) before the output from `fetchUserOrder()` (“Large Latte”). This is because `fetchUserOrder()` delays before it prints “Large Latte”.

It's not because of the delay, it's because "Large Latte" is inside a `Future`.

#### Async and Await

If the function has a declared return type, then update the type to be `Future<T>`, where `T` is the type of the value that the function returns. If the function doesn’t explicitly return a value, then the return type is `Future<void>`:

```dart
Future<void> main() async { ··· }
```

### [Dart Microtasks Example][microtask_example]  

```dart
import 'dart:async';

main() {
  // Future() schedules a task on the event queue:
  Future(() => print('world'));
  print('hello');

  // scheduleMicrotask() will add the task to the microtask queue:
  // Tasks on the microtask queue are executed before the next
  // run-loop on the event queue.
  scheduleMicrotask(() => print('beautiful'));

  print('there');
}
```

```bash
$ dart microtasks.dart
hello
there
beautiful
world
```

### [Flutter execute code with MicroTask queue and Event queue][devexps_medium_1]

- Dart is a single threaded language
    - First thing, everyone need to known that Dart is a single thread and Flutter relies on Dart.

#### The Dart Execution Model

After **main thread** created, Dart automatically:

1. initializes 2 Queues, namely `MicroTask` and `Event` FIFO queues;
2. executes the `main()` method and, once this code execution is completed;
3. launches the `Event Loop`

![Event-Microtask Loop][event_microtask_loop]


[event_microtask_loop]: assets/event_microtask_loop.png