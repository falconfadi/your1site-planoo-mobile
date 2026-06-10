import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/court/court_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CourtDetailsParams extends BaseParams {

  final int courtId;


  CourtDetailsParams({required this.courtId});
}

class CourtDetailsUseCase extends UseCase<CourtModel, CourtDetailsParams> {
  final HomeRepository repository;

  CourtDetailsUseCase(this.repository);

  @override
  Future<Result<CourtModel>> call({required CourtDetailsParams params}) {
    return repository.getCourtDetails(params: params);
  }
}
