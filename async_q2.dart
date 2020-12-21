import "dart:async";

void main() {
  print("main #1 of 2");
  scheduleMicrotask(() => print("microtask #1 of 3"));

  Future.delayed(Duration(seconds: 1), () => print("future #1 (delayed)"));

  Future(() => print("future #2 of 4"))
      .then((_) => print("future #2a"))
      .then((_) {
    print("future #2b");
    scheduleMicrotask(() => print("microtask #0 (from future #2b)"));
  }).then((_) => print("future #2c"));

  scheduleMicrotask(() => print("microtask #2 of 3"));

  Future(() => print("future #3 of 4"))
      .then((_) => Future(() => print("future #3a (a new future)")))
      .then((_) => print("future #3b"));

  Future(() => print("future #4 of 4"));
  scheduleMicrotask(() => print("microtask #3 of 3"));
  print("main #2 of 2");
}

// Note that bugs 9001 and 9002 have been fixed, which is different from the
// original post: https://web.archive.org/web/20170704074724/https://webdev.dartlang.org/articles/performance/event-loop

// Will print:
//
// main #1 of 2
// main #2 of 2
// microtask #1 of 3
// microtask #2 of 3
// microtask #3 of 3
// future #2 of 4
// future #2a
// future #2b
// future #2c
// microtask #0 (from future #2b)
// future #3 of 4
// future #4 of 4
// future #3a (a  future)
// future #3b
// future #1 (delayed)

// All the then() callbacks execute as soon as the Future they’re invoked on
// completes. Thus, future 2, 2a, 2b, and 2c execute all in one go, before
// control returns to the embedder. Similarly, future 3a and 3b execute all in
//   one go.
