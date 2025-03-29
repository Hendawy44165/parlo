class ResponseModel<T> {
  final ResponseState state;
  final T? data;
  final String? error;
  final int errorCode;

  const ResponseModel.success(T this.data)
    : state = ResponseState.success,
      error = null,
      errorCode = 0;

  const ResponseModel.failure(this.errorCode, this.error)
    : state = ResponseState.failure,
      data = null;

  bool get isSuccess => state == ResponseState.success;
  bool get isFailure => state == ResponseState.failure;
}

enum ResponseState { success, failure }
