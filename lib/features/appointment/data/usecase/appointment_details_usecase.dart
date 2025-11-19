import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import 'package:centro_partner/features/appointment/data/model/appointment_details_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class AppointmentDetailsParams extends BaseParams {

  final int appointmentId;

  AppointmentDetailsParams({required this.appointmentId});
}

class AppointmentDetailsUseCase extends UseCase<AppointmentDetailsModel, AppointmentDetailsParams> {
  final AppointmentRepository repository;

  AppointmentDetailsUseCase(this.repository);

  @override
  Future<Result<AppointmentDetailsModel>> call({required AppointmentDetailsParams params}) {
    return repository.getAppointmentDetails(params: params);
  }
}
