import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/data_source/remote_data_source.dart';
import 'package:centro_partner/core/http/http_method.dart';
import 'package:centro_partner/core/repository/core_repository.dart';
import 'package:centro_partner/core/results/result.dart';
import 'package:centro_partner/features/appointment/data/model/accepted_appointments_model.dart';
import 'package:centro_partner/features/appointment/data/model/all_appointments_model.dart';
import 'package:centro_partner/features/appointment/data/model/slots_model.dart';
import 'package:centro_partner/features/appointment/data/usecase/accepted_appointments_usecase.dart';
import 'package:centro_partner/features/appointment/data/usecase/appointment_details_usecase.dart';
import 'package:centro_partner/features/appointment/data/usecase/cancel_court_appointment_usecase.dart';
import 'package:centro_partner/features/appointment/data/usecase/check_court_appointment_usecase.dart';
import 'package:centro_partner/features/appointment/data/usecase/create_court_appointment_usecase.dart';
import 'package:centro_partner/features/appointment/data/usecase/all_appointments_usecase.dart';
import '../model/appointment_details_model.dart';

class AppointmentRepository extends CoreRepository {

  Future<Result<List<AppointmentDetailsModel>>> getAllAppointments({required AllAppointmentsParams params}) async {
    String query = "page=${params.request.page}";
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: "$allAppointmentsUrl/${params.ownerType}?$query",
        method: HttpMethod.POST,
        data: params.toJson(),
        responseStr: 'AllAppointmentsResponse',
        converter: (json) => AllAppointmentsResponse.fromJson(json));
    return paginatedCall(result: result);
  }

  Future<Result<AppointmentDetailsModel>> getAppointmentDetails({required AppointmentDetailsParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: "$getAppointmentDetailsUrl?appointment_id=${params.appointmentId}",
        method: HttpMethod.GET,
        responseStr: 'AppointmentDetailsResponse',
        converter: (json) => AppointmentDetailsResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<SlotsModel>> checkCourtAppointment({required CheckCourtAppointmentParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: checkCourtAppointmentUrl,
        data: params.toJson(),
        method: HttpMethod.POST,
        responseStr: 'SlotsResponse',
        converter: (json) => SlotsResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<bool>> createCourtAppointment({required CreateCourtAppointmentParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
        withAuthentication: true,
        url: createCourtAppointmentUrl,
        data: params.toJson(),
        method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<bool>> cancelCourtAppointment({required CancelCourtAppointmentParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: cancelCourtAppointmentUrl,
      data: params.toJson(),
      method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<AcceptedAppointmentsModel>> getAcceptedAppointments({required AcceptedAppointmentsParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: "$acceptedAppointmentsUrl/${params.ownerType}",
        method: HttpMethod.POST,
        responseStr: 'AcceptedAppointmentsResponse',
        converter: (json) => AcceptedAppointmentsResponse.fromJson(json));
    return call(result: result);
  }

}
