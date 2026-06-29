class ResponseState<T> {
  ResponseState._();
  factory ResponseState.success(T value) = SuccessState<T>;
  factory ResponseState.error(T value) = ErrorState<T>;
}

class ErrorState<T> extends ResponseState<T> {
  ErrorState(this.value) : super._();
  final T value;
}

class SuccessState<T> extends ResponseState<T> {
  SuccessState(this.value) : super._();
  final T value;
}

class ErrorModel {
  final String? status;
  final String? message;
  final dynamic data;

  ErrorModel({this.status, this.message, this.data});
}
