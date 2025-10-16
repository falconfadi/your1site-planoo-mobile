import 'package:centro_partner/core/boilerplate/pagination/models/get_list_request.dart';
import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import 'package:centro_partner/features/appointment/data/model/appointment_details_model.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class AllAppointmentsParams extends BaseParams {

  final GetListRequest request;
  final String ownerType;
  final String? date;
  int status = 0; /// by default (status = 0 => accepted)

  AllAppointmentsParams(this.request, {
    required this.ownerType,
    this.date,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "pageOption": request.toJson(),
      "filters":{
        if (date != null)"date":date,
        "status": status
      },
    };
  }
}

class AllAppointmentsUseCase extends UseCase<List<AppointmentDetailsModel>, AllAppointmentsParams> {
  final AppointmentRepository repository;

  AllAppointmentsUseCase(this.repository);

  @override
  Future<Result<List<AppointmentDetailsModel>>> call({required AllAppointmentsParams params}) {
    return repository.getAllAppointments(params: params);
  }
}
