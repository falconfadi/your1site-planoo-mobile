import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import 'package:centro_partner/features/appointment/data/model/slots_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CheckCourtAppointmentParams extends BaseParams {

  final int courtId;
  final int dayId;
  final String date;
  final int sessionDuration;

  CheckCourtAppointmentParams({
    required this.courtId,
    required this.dayId,
    required this.date,
    required this.sessionDuration,
  });

  Map<String, dynamic> toJson() {
    return {
      'activity_id': courtId,
      'day_id': dayId,
      'date': date,
      'session_duration': sessionDuration,
    };
  }
}

class CheckCourtAppointmentUseCase extends UseCase<SlotsModel, CheckCourtAppointmentParams> {
  final AppointmentRepository repository;

  CheckCourtAppointmentUseCase(this.repository);

  @override
  Future<Result<SlotsModel>> call({required CheckCourtAppointmentParams params}) {
    return repository.checkCourtAppointment(params: params);
  }
}
