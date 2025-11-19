import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/review_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class ReviewsParams extends BaseParams {

  final String ownerType;
  final int ownerId;

  ReviewsParams({
    required this.ownerType,
    required this.ownerId,
  });

}

class ReviewsUseCase extends UseCase<ReviewModel, ReviewsParams> {
  final HomeRepository repository;

  ReviewsUseCase(this.repository);

  @override
  Future<Result<ReviewModel>> call({required ReviewsParams params}) {
    return repository.getReviews(params: params);
  }
}
