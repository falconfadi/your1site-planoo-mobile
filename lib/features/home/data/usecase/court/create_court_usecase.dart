import 'dart:io';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/court/court_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CreateCourtParams extends BaseParams {

  final String name;
  final int categoryId;
  final String description;
  final int sessionDuration;
  final String price;
  final double longitude;
  final double latitude;
  final String fromTime;
  final String endTime;
  final List<int> tags;
  final List<String> days;
  final List<File>? files;

  CreateCourtParams({
    required this.name,
    required this.categoryId,
    required this.description,
    required this.sessionDuration,
    required this.price,
    required this.longitude,
    required this.latitude,
    required this.fromTime,
    required this.endTime,
    required this.tags,
    required this.days,
    this.files,
  });

  Map<String, dynamic> toFormDataMap() {
    Map<String, dynamic> data = {
      'name': name,
      'category_id': categoryId.toString(),
      'description': description,
      'session_duration': sessionDuration.toString(),
      'price': price,
      'type': 'image',
      'long': longitude.toString(),
      'lat': latitude.toString(),
    };

    for (int i = 0; i < days.length; i++) {
      data['days[$i][day]'] = days[i];
      data['days[$i][start]'] = fromTime;
      data['days[$i][end]'] = endTime;
    }

    data['tags[]'] = tags.map((t) => t.toString()).toList();

    return data;
  }
}

class CreateCourtUseCase extends UseCase<CourtModel, CreateCourtParams> {
  final HomeRepository repository;

  CreateCourtUseCase(this.repository);

  @override
  Future<Result<CourtModel>> call({required CreateCourtParams params}) {
    return repository.createCourt(params: params);
  }
}
