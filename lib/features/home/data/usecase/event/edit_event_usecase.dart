import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/event/event_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class EditEventParams extends BaseParams {

  final int eventId;
  final String name;
  final int categoryId;
  final String description;
  final String eventDuration;
  final String capacity;
  final String admissionFee;
  final String withdrawalFee;
  final String startDate;


  EditEventParams({
    required this.eventId,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.eventDuration,
    required this.capacity,
    required this.admissionFee,
    required this.withdrawalFee,
    required this.startDate,
  });

  Map<String, String?> toJson() {
    return {
      'event_id': eventId.toString(),
      'name': name,
      'category_id': categoryId.toString(),
      'description': description,
      'event_duration': eventDuration,
      'capacity': capacity,
      'admission_fee': admissionFee,
      'withdrawal_fee': withdrawalFee,
      'start_date': startDate,
    };
  }
}

class EditEventUseCase extends UseCase<EventModel, EditEventParams> {
  final HomeRepository repository;

  EditEventUseCase(this.repository);

  @override
  Future<Result<EventModel>> call({required EditEventParams params}) {
    return repository.editEvent(params: params);
  }
}
