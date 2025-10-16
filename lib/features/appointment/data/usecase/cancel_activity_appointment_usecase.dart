import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CancelActivityAppointmentParams extends BaseParams {

  final int appointmentId;

  CancelActivityAppointmentParams({
    required this.appointmentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
    };
  }
}

class CancelActivityAppointmentUseCase extends UseCase<bool, CancelActivityAppointmentParams> {
  final AppointmentRepository repository;

  CancelActivityAppointmentUseCase(this.repository);

  @override
  Future<Result<bool>> call({required CancelActivityAppointmentParams params}) {
    return repository.cancelActivityAppointment(params: params);
  }
}
