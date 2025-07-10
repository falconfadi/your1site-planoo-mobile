import '../params/base_params.dart';
import '../results/result.dart';

abstract class UseCase<Type, Params extends BaseParams> {
  Future<Result<Type>> call({required Params params});
}
