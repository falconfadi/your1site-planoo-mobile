import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/appointment/data/model/appointment_details_model.dart';

class AcceptedAppointmentsResponse extends ApiResponse<AcceptedAppointmentsModel> {
  AcceptedAppointmentsResponse({required super.errors, required super.message, required super.data});

  factory AcceptedAppointmentsResponse.fromJson(Map<String, dynamic> json) {
    return AcceptedAppointmentsResponse(
      errors: json["payload"]["errors"] != null
          ? AcceptedAppointmentsModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: AcceptedAppointmentsModel.fromJson(json["payload"]),
    );
  }
}

class AcceptedAppointmentsModel extends BaseModel {

  List<AppointmentDetailsModel>? appointmentsList;

  AcceptedAppointmentsModel({this.appointmentsList});

  AcceptedAppointmentsModel.fromJson(Map<String, dynamic> json) {
    if (json['appointments'] != null) {
      appointmentsList = <AppointmentDetailsModel>[];
      json['appointments'].forEach((v) {
        appointmentsList!.add(AppointmentDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.appointmentsList != null) {
      data['appointments'] = this.appointmentsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}