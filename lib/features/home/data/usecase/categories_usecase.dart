import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/category_model.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class CategoriesParams extends BaseParams {

  CategoriesParams();
}

class CategoriesUseCase extends UseCase<CategoryModel, CategoriesParams> {
  final HomeRepository repository;

  CategoriesUseCase(this.repository);

  @override
  Future<Result<CategoryModel>> call({required CategoriesParams params}) {
    return repository.getCategories(params: params);
  }
}
