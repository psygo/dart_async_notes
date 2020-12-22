# Dart Async Notes

## Resources

| Article                                                           | Domain               |
| ----------------------------------------------------------------- | -------------------- |
| [Asynchronous programming: futures, async, await][dart.dev_async] | [dart.dev][dart.dev] |


[dart.dev]: https://dart.dev/
[dart.dev_async]: https://dart.dev/codelabs/async-await#why-asynchronous-code-matters

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