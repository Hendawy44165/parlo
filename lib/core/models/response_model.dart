import 'package:parlo/core/enums/codes_enum.dart';

class ResponseModel<T> {
  final ResponseState state;
  final T? data;
  final String? error;
  final Codes? errorCode;

  const ResponseModel.success(T this.data)
    : state = ResponseState.success,
      error = null,
      errorCode = null;

  const ResponseModel.failure(this.errorCode, this.error)
    : state = ResponseState.failure,
      data = null;

  bool get isSuccess => state == ResponseState.success;
  bool get isFailure => state == ResponseState.failure;
}

enum ResponseState { success, failure }
