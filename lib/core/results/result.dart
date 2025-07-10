import '../data_source/model.dart';
import '../errors/base_error.dart';

class Result<Data> {
  Result({
    this.data,
    this.error,
  }) : assert(data != null || error != null);
  final Data? data;
  final BaseError? error;

  bool get hasDataOnly => data != null && error == null;

  bool get hasErrorOnly => data == null;

  bool get hasDataAndError => data != null;
}

class RemoteResult<Data extends BaseModel> extends Result<Data> {
  RemoteResult({Data? data, BaseError? error}) : super(data: data, error: error);
}

class PaginatedResult<Data extends BaseModel> extends Result<List<Data>> {
  PaginatedResult({List<Data>? data, BaseError? error}) : super(data: data, error: error);
}
