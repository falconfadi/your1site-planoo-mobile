import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/data_source/remote_data_source.dart';
import 'package:centro_partner/core/http/http_method.dart';
import 'package:centro_partner/core/repository/core_repository.dart';
import 'package:centro_partner/core/results/result.dart';
import 'package:centro_partner/features/general/data/model/main_court/all_main_courts_model.dart';
import 'package:centro_partner/features/general/data/model/main_court/check_new_main_court_model.dart';
import 'package:centro_partner/features/general/data/model/main_court/main_court_model.dart';
import 'package:centro_partner/features/general/data/usecase/main_court/all_main_courts_usecase.dart';
import 'package:centro_partner/features/general/data/usecase/main_court/check_new_main_court_usecase.dart';
import 'package:centro_partner/features/general/data/usecase/main_court/create_main_court_usecase.dart';
import 'package:centro_partner/features/general/data/usecase/main_court/delete_main_court_usecase.dart';
import 'package:centro_partner/features/general/data/usecase/main_court/edit_main_court_usecase.dart';

class GeneralRepository extends CoreRepository {

  Future<Result<AllMainCourtsModel>> getAllMainCourts({required AllMainCourtsParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: allMainCourtsUrl,
        method: HttpMethod.GET,
        responseStr: 'AllMainCourtsResponse',
        converter: (json) => AllMainCourtsResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<MainCourtModel>> createMainCourt({required CreateMainCourtParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: createMainCourtUrl,
        data: params.toJson(),
        method: HttpMethod.POST,
        responseStr: 'MainCourtResponse',
        converter: (json) => MainCourtResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<MainCourtModel>> editMainCourt({required EditMainCourtParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: editMainCourtUrl,
        data: params.toJson(),
        method: HttpMethod.POST,
        responseStr: 'MainCourtResponse',
        converter: (json) => MainCourtResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<bool>> deleteMainCourt({required DeleteMainCourtParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: deleteMainCourtUrl,
      data: params.toJson(),
      method: HttpMethod.DELETE,
    );
    return noModelCall(result: result);
  }

  Future<Result<CheckNewMainCourtModel>> checkNewMainCourt({required CheckNewMainCourtParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: checkNewMainCourtUrl,
        method: HttpMethod.GET,
        responseStr: 'CheckNewMainCourtResponse',
        converter: (json) => CheckNewMainCourtResponse.fromJson(json));
    return call(result: result);
  }
}
