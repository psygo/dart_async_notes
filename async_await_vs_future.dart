// If the function has a declared return type, then update the type to be
// Future<T>, where T is the type of the value that the function returns. If the
// function doesn’t explicitly return a value, then the return type is
// Future<void>

// From: https://dart.dev/codelabs/async-await#working-with-futures-async-and-await
import 'dart:async';

Future<void> main() async {
  print("Start");

  scheduleMicrotask(() => print("microtask #0"));

  futurePrinter("before await");

  print("regular print before await");

  scheduleMicrotask(() => print("microtask #1"));
  
  await futurePrinter("await");

  scheduleMicrotask(() => print("microtask #2"));

  futurePrinter("in-between awaits");
  futurePrinter("in-between awaits");

  await futurePrinter("await");

  print("regular print after await");

  futurePrinter("after await");

  print("End");
}

Future<void> futurePrinter(String toPrint) {
  return Future<void>(() => print(toPrint));
}

// The `await` keyword is forcing the EventLoop to complete until it finishes
// the current await, while also behaving as synchronous code. So that's why the
// enqueued "before await" is executed before the await code itself.

// Will print
//
// Start
// regular print before await
// microtask #0
// microtask #1
// before await
// await
// microtask #2
// in-between awaits
// in-between awaits
// await
// regular print after await
// End
// after await
