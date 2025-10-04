import '../params/base_params.dart';
import '../results/result.dart';

abstract class UseCase<T, Params extends BaseParams> {
  Future<Result<T>> call({required Params params});
}
