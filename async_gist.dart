import "dart:async";

void longLoop(String toPrint) {
  const int lastNumber = 10000000000;
  for (int i = 0; i <= lastNumber; i++) if (i == lastNumber) print(toPrint);
}

void main() {
  print("Start");

  Future(() {
    print("from Future 1");

    scheduleMicrotask(() => print("microtask 1 from future"));

    longLoop("long loop from Future");

    scheduleMicrotask(() => print("microtask 2 from future"));
  });

  longLoop("long loop 1");

  longLoop("long loop 2");

  scheduleMicrotask(() => print("microtask 1"));

  Future(() => print("from Future 2"));

  scheduleMicrotask(() => print("microtask 2"));

  print("End");
}

// Don't forget it all works as a FIFO, a regular queue.

// Will print:
//
// Start
// long loop 1
// long loop 2
// End
// microtask 1
// microtask 2
// from Future 1
// long loop from Future
// microtask 1 from future
// microtask 2 from future
// from Future 2
