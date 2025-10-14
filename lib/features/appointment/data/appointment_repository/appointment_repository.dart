import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/data_source/remote_data_source.dart';
import 'package:centro_partner/core/http/http_method.dart';
import 'package:centro_partner/core/repository/core_repository.dart';
import 'package:centro_partner/core/results/result.dart';
import 'package:centro_partner/features/appointment/data/model/slots_model.dart';
import 'package:centro_partner/features/appointment/data/usecase/check_activity_appointment_usecase.dart';
import 'package:centro_partner/features/appointment/data/usecase/create_activity_appointment_usecase.dart';

class AppointmentRepository extends CoreRepository {

  Future<Result<SlotsModel>> checkActivityAppointment({required CheckActivityAppointmentParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: checkActivityAppointmentUrl,
        data: params.toJson(),
        method: HttpMethod.POST,
        responseStr: 'SlotsResponse',
        converter: (json) => SlotsResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<bool>> createActivityAppointment({required CreateActivityAppointmentParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
        withAuthentication: true,
        url: createActivityAppointmentUrl,
        data: params.toJson(),
        method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

}
