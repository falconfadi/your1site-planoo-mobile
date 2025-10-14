import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import 'package:centro_partner/features/appointment/data/model/slots_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CheckActivityAppointmentParams extends BaseParams {

  final int activityId;
  final int dayId;
  final String date;
  final int sessionDuration;

  CheckActivityAppointmentParams({
    required this.activityId,
    required this.dayId,
    required this.date,
    required this.sessionDuration,
  });

  Map<String, dynamic> toJson() {
    return {
      'activity_id': activityId,
      'day_id': dayId,
      'date': date,
      'session_duration': sessionDuration,
    };
  }
}

class CheckActivityAppointmentUseCase extends UseCase<SlotsModel, CheckActivityAppointmentParams> {
  final AppointmentRepository repository;

  CheckActivityAppointmentUseCase(this.repository);

  @override
  Future<Result<SlotsModel>> call({required CheckActivityAppointmentParams params}) {
    return repository.checkActivityAppointment(params: params);
  }
}
