import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CreateActivityAppointmentParams extends BaseParams {

  final int activityId;
  final String code;
  final int dayId;
  final String date;
  final int sessionDuration;
  final String time;
  final String? note;
  final String customerPhone;

  CreateActivityAppointmentParams({
    required this.activityId,
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
      'activity_id': activityId,
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

class CreateActivityAppointmentUseCase extends UseCase<bool, CreateActivityAppointmentParams> {
  final AppointmentRepository repository;

  CreateActivityAppointmentUseCase(this.repository);

  @override
  Future<Result<bool>> call({required CreateActivityAppointmentParams params}) {
    return repository.createActivityAppointment(params: params);
  }
}
