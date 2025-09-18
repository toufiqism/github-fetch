sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;

  Success<T> get asSuccess => this as Success<T>;
  Error<T> get asError => this as Error<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Object error;
  const Error(this.error);
}

