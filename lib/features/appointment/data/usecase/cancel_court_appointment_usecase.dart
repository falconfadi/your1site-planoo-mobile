import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CancelCourtAppointmentParams extends BaseParams {

  final int appointmentId;

  CancelCourtAppointmentParams({
    required this.appointmentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
    };
  }
}

class CancelCourtAppointmentUseCase extends UseCase<bool, CancelCourtAppointmentParams> {
  final AppointmentRepository repository;

  CancelCourtAppointmentUseCase(this.repository);

  @override
  Future<Result<bool>> call({required CancelCourtAppointmentParams params}) {
    return repository.cancelCourtAppointment(params: params);
  }
}
