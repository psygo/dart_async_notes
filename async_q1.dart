import "dart:async";

void main() {
  print("main #1 of 2");
  scheduleMicrotask(() => print("microtask #1 of 2"));

  Future.delayed(Duration(seconds: 1), () => print("future #1 (delayed)"));
  Future(() => print("future #2 of 3"));
  Future(() => print("future #3 of 3"));

  scheduleMicrotask(() => print("microtask #2 of 2"));

  print("main #2 of 2");
}

// Currently, if you comment out the first call to scheduleMicrotask(), then the
// callbacks for futures #2 and #3 execute before microtask #2. This is due to
// bugs 9001 and 9002, as discussed in Microtask queue: scheduleMicrotask().

// Will print:
//
// main #1 of 2
// main #2 of 2
// microtask #1 of 2
// microtask #2 of 2
// future #2 of 3
// future #3 of 3
// future #1 (delayed)
