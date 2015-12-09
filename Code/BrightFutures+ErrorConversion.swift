import BrightFutures

public extension Future where T: NilLiteralConvertible {

  /// Discards the error in this future and returns a future that always succeeds. The result type is made `nil` if
  /// the future has failed.
  func discardError() -> Future<T, NoError> {
    return recover { _ in nil }
  }

}

public extension Future {

  /// Returns a future that uses a boolean to indicate whether the operation succeeded.
  func asBool() -> Future<Bool, NoError> {
    let boolFuture = map { _ in true }
    return boolFuture.recover { _ in false }
  }

  /// Voids the future and discards the error.
  func voidAndDiscardError() -> Future<Void, NoError> {
    let voidFuture = map { _ in }
    return voidFuture.recover { _ in }
  }

  /// Flatmaps the future into one that uses a different error type. Any error is discarded, as it cannot be mapped.
  func flatMapDiscardingError<U, V: ErrorType>(context: ExecutionContext, task: (T) -> Future<U, V>) -> Future<U, V> {
    let promise = Promise<U, V>()

    onSuccess(context) { (value: T) in
      promise.completeWith(task(value))
    }
    return promise.future
  }

  func flatMapDiscardingError<U, V: ErrorType>(task: (T) -> Future<U, V>) -> Future<U, V> {
    return flatMapDiscardingError(ImmediateExecutionContext, task: task)
  }

}