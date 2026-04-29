import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import 'package:centro_partner/features/appointment/data/model/accepted_appointments_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class AcceptedAppointmentsParams extends BaseParams {

  final String ownerType;

  AcceptedAppointmentsParams({
    required this.ownerType,
  });
}

class AcceptedAppointmentsUseCase extends UseCase<AcceptedAppointmentsModel, AcceptedAppointmentsParams> {
  final AppointmentRepository repository;

  AcceptedAppointmentsUseCase(this.repository);

  @override
  Future<Result<AcceptedAppointmentsModel>> call({required AcceptedAppointmentsParams params}) {
    return repository.getAcceptedAppointments(params: params);
  }
}
