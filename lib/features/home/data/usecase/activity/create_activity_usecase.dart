import 'dart:io';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/activity/activity_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CreateActivityParams extends BaseParams {

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

  CreateActivityParams({
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

  Map<String, String?> toJson() {
    return {
      'name': name,
      'category_id': categoryId.toString(),
      'description': description,
      'session_duration': sessionDuration.toString(),
      'price': price,
      'type': 'image',
      'long': longitude.toString(),
      'lat': latitude.toString(),

      for (var tag in tags) 'tags[]': tag.toString(),

      for (int i = 0; i < days.length; i++) ...{
        'days[$i][day]': days[i],
        'days[$i][start]': fromTime,
        'days[$i][end]': endTime,
        },
      };
  }
}

class CreateActivityUseCase extends UseCase<ActivityModel, CreateActivityParams> {
  final HomeRepository repository;

  CreateActivityUseCase(this.repository);

  @override
  Future<Result<ActivityModel>> call({required CreateActivityParams params}) {
    return repository.createActivity(params: params);
  }
}
