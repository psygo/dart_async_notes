// If the function has a declared return type, then update the type to be 
// Future<T>, where T is the type of the value that the function returns. If the
// function doesn’t explicitly return a value, then the return type is 
// Future<void>

// From: https://dart.dev/codelabs/async-await#working-with-futures-async-and-await
Future<void> main() async {
  print("Start");

  printer("before await");

  print("regular print before await");

  await printer("await");

  print("regular print after await");

  printer("after await");

  print("End");
}

Future<void> printer(String toPrint) {
  return Future<void>(() => print(toPrint));
}

// The `await` keyword is forcing the EventLoop to complete until it finishes 
// the current await. So that's why the enqueued "before await" is executed
// before the await code itself.

// Will print
//
// Start
// regular print before await
// before await
// await
// regular print after await
// End
// after await
