# Dart Async Notes

**Table of Contents**

<!-- TOC depthFrom:2 -->

- [1. Resources](#1-resources)
- [2. Articles](#2-articles)
    - [2.1. Asynchronous programming: futures, async, await](#21-asynchronous-programming-futures-async-await)
        - [2.1.1. Async and Await](#211-async-and-await)
    - [2.2. Dart Microtasks Example](#22-dart-microtasks-example)
    - [2.3. Flutter execute code with MicroTask queue and Event queue](#23-flutter-execute-code-with-microtask-queue-and-event-queue)
        - [2.3.1. The Dart Execution Model](#231-the-dart-execution-model)
    - [2.4. The Event Loop and Dart](#24-the-event-loop-and-dart)
        - [2.4.1. Facts about `Future`](#241-facts-about-future)
        - [2.4.2. Microtask](#242-microtask)
        - [2.4.3. Isolates](#243-isolates)
        - [2.4.4. Q2](#244-q2)

<!-- /TOC -->

## 1. Resources

| Index | Article                                                                       | Domain                           |
| ----- | ----------------------------------------------------------------------------- | -------------------------------- |
| 1     | [Asynchronous programming: futures, async, await][dart.dev_async]             | [dart.dev][dart.dev]             |
| 2     | [Dart Microtasks Example][microtask_example]                                  | [jpryan.me][jpryan]              |
| 3     | [Flutter execute code with MicroTask queue and Event queue][devexps_medium_1] | [devexps Medium][devexps_medium] |
| 4     | [The Event Loop and Dart][event_loop_archive]                                 | [WebArchive][web_archive]        |


[dart.dev]: https://dart.dev/
[dart.dev_async]: https://dart.dev/codelabs/async-await#why-asynchronous-code-matters
[devexps_medium]: https://medium.com/@devexps/
[devexps_medium_1]: https://medium.com/@devexps/flutter-execute-code-with-microtask-queue-and-event-queue-f2dc10b06aad
[event_loop_archive]: https://web.archive.org/web/20170704074724/https://webdev.dartlang.org/articles/performance/event-loop
[jpryan]: http://jpryan.me/
[microtask_example]: http://jpryan.me/dartbyexample/examples/microtasks/
[web_archive]: https://web.archive.org/

## 2. Articles

### 2.1. [Asynchronous programming: futures, async, await][dart.dev_async]

**Key terms:**

- **synchronous operation**: A synchronous operation blocks other operations from executing until it completes.
- **synchronous function**: A synchronous function only performs synchronous operations.
- **asynchronous operation**: Once initiated, an asynchronous operation allows other operations to execute before it completes.
- **asynchronous function**: An asynchronous function performs at least one asynchronous operation and can also perform *synchronous* operations.

*This explanation is wrong*:

> In the preceding example, even though `fetchUserOrder()` executes before the `print()` call on line 8, the console shows the output from line 8 (“Fetching user order…”) before the output from `fetchUserOrder()` (“Large Latte”). This is because `fetchUserOrder()` delays before it prints “Large Latte”.

It's not because of the delay, it's because "Large Latte" is inside a `Future`.

#### 2.1.1. Async and Await

If the function has a declared return type, then update the type to be `Future<T>`, where `T` is the type of the value that the function returns. If the function doesn’t explicitly return a value, then the return type is `Future<void>`:

```dart
Future<void> main() async { ··· }
```

### 2.2. [Dart Microtasks Example][microtask_example]  

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

### 2.3. [Flutter execute code with MicroTask queue and Event queue][devexps_medium_1]

- Dart is a single threaded language
    - First thing, everyone need to known that Dart is a single thread and Flutter relies on Dart.

#### 2.3.1. The Dart Execution Model

After **main thread** created, Dart automatically:

1. initializes 2 Queues, namely `MicroTask` and `Event` FIFO queues;
2. executes the `main()` method and, once this code execution is completed;
3. launches the `Event Loop`

![Event-Microtask Loop][event_microtask_loop]


[event_microtask_loop]: assets/event_microtask_loop.png

### 2.4. [The Event Loop and Dart][event_loop_archive]

In addition to executing your code, `then()` returns a future of its own, matching the return value of whatever function you give it.

If a task absolutely must complete before any items from the event queue are handled, then you should usually just execute the function immediately. If you can’t, then use `scheduleMicrotask()` to add an item to the microtask queue. For example, in a web app use a microtask to avoid prematurely releasing a `js-interop` proxy or ending an `IndexedDB` transaction or event handler.

> You can also use `Timer` to schedule tasks, but if any uncaught exceptions occur in the task, your app will exit. Instead, we recommend Future, which is built on top of Timer and adds features such as detecting task completion and responding to errors.

> If you’re drawing frames for animation in a web app, don’t use a Future (or `Timer` or Stream). Instead, use `animationFrame`, which is the Dart interface to `requestAnimationFrame`.

#### 2.4.1. Facts about `Future`

1. The function that you pass into `Future`’s **`then()`** method executes immediately when the `Future` completes. (The function isn’t enqueued, it’s just called.)
2. If a `Future` is *already complete* before **`then()`** is invoked on it, then a task is added to the *microtask queue*, and *that* task executes the function passed into `then()`.
3. The **`Future()`** and **`Future.delayed()`** constructors don’t complete immediately; they add an item to the event queue.
4. The **`Future.value()`** constructor completes in a microtask, similar to #2.
5. The **`Future.sync()`** constructor executes its function argument immediately and (unless that function returns a `Future`) completes in a microtask, similar to #2.

#### 2.4.2. Microtask

~~Due to bugs `9001` and `9002`, the first call to `scheduleMicrotask()` schedules a task on the event queue; this task creates the microtask queue and enqueues the function specified to `scheduleMicrotask()`. As long as the microtask queue has at least one entry, subsequent calls to `scheduleMicrotask()` correctly add to the microtask queue. Once the microtask queue is empty, it must be created again the next time `scheduleMicrotask()` is called.~~

The upshot of these bugs: The first task that you schedule with `scheduleMicrotask()` seems like it’s on the event queue.

A workaround is to put your first call to `scheduleMicrotask()` before your first call to new Future(). This creates the microtask queue before executing other tasks on the event queue. However, it doesn’t stop external events from being added to the event queue. It also doesn’t help when you have a delayed task.

Another way to add a task to the microtask queue is to invoke then() on a Future that’s already complete. See the previous section for more information.

#### 2.4.3. Isolates

What if you have a compute-intensive task to run? To keep your app responsive, you should put the task into its own isolate or worker. Isolates might run in a separate process or thread, depending on the Dart implementation. In 1.0 we don’t expect web apps to support isolates or Dart-language workers. However, you can use the `dart:html` `Worker` class to add a JavaScript worker to a Dart web app.

How many isolates should you use? For compute-intensive tasks, you should generally use as many isolates as you expect to have CPUs available. Any additional isolates are just wasted if they’re purely computational. However, if the isolates perform asynchronous calls—to perform I/O, for example—then they won’t spend much time on the CPUs, so having more isolates than CPUs makes sense.

#### 2.4.4. Q2

Like before, the `main()` function executes, and then everything on the microtask queue, and then tasks on the event queue. Here are a few interesting points:

- When the `then()` callback for future 3 calls new `Future()`, it creates a new task (#3a) that’s added to the end of the event queue.
- All the `then()` callbacks execute as soon as the Future they’re invoked on completes. Thus, future 2, 2a, 2b, and 2c execute all in one go, before control returns to the embedder. Similarly, future 3a and 3b execute all in one go.
- If you change the 3a code from `then((_) => new Future(...))` to `then((_) {new Future(...); })`, then “future #3b” appears earlier (after future #3, instead of future #3a). The reason is that returning a `Future` from your callback is how you get `then()` (which itself returns a new Future) to *chain* those two Futures together, so that the Future returned by `then()` completes when the Future returned by the callback completes. See the [`then()` reference](https://web.archive.org/web/20170704074724/https://api.dartlang.org/stable/dart-async/Future/then.html) for more information.