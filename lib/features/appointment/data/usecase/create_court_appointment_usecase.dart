import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CreateCourtAppointmentParams extends BaseParams {

  final int courtId;
  final String code;
  final int dayId;
  final String date;
  final int sessionDuration;
  final String time;
  final String? note;
  final String customerPhone;

  CreateCourtAppointmentParams({
    required this.courtId,
    required this.code,
    required this.dayId,
    required this.date,
    required this.sessionDuration,
    required this.time,
    this.note,
    required this.customerPhone
  });

  Map<String, dynamic> toJson() {
    return {
      'activity_id': courtId,
      'code': code,
      'day_id': dayId,
      'date': date,
      'session_duration': sessionDuration,
      'time': time,
      'notes': note,
      'customer_phone': customerPhone,
    };
  }
}

class CreateCourtAppointmentUseCase extends UseCase<bool, CreateCourtAppointmentParams> {
  final AppointmentRepository repository;

  CreateCourtAppointmentUseCase(this.repository);

  @override
  Future<Result<bool>> call({required CreateCourtAppointmentParams params}) {
    return repository.createCourtAppointment(params: params);
  }
}
