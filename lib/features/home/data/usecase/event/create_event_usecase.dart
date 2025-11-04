import 'dart:io';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/event/event_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CreateEventParams extends BaseParams {

  final String name;
  final int categoryId;
  final String description;
  final String eventDuration;
  final String capacity;
  final String admissionFee;
  final String withdrawalFee;
  final String startDate;
  final double longitude;
  final double latitude;
  final String? fromTime;
  final String? endTime;
  final List<String>? days;
  final List<int> tags;
  final List<File>? files;

  CreateEventParams({
    required this.name,
    required this.categoryId,
    required this.description,
    required this.eventDuration,
    required this.capacity,
    required this.admissionFee,
    required this.withdrawalFee,
    required this.startDate,
    required this.longitude,
    required this.latitude,
    this.fromTime,
    this.endTime,
    this.days,
    required this.tags,
    this.files,
  });

  Map<String, dynamic> toFormDataMap() {
    Map<String, dynamic> data = {
      'name': name,
      'category_id': categoryId.toString(),
      'description': description,
      'event_duration': eventDuration,
      'capacity': capacity,
      'admission_fee': admissionFee,
      'withdrawal_fee': withdrawalFee,
      'start_date': startDate,
      'type': 'image',
      'long': longitude.toString(),
      'lat': latitude.toString(),
    };

    for (int i = 0; i < days!.length; i++) {
      data['days[$i][day]'] = days![i];
      data['days[$i][start]'] = fromTime;
      data['days[$i][end]'] = endTime;
    }

    data['tags[]'] = tags.map((t) => t.toString()).toList();

    return data;
  }
}

class CreateEventUseCase extends UseCase<EventModel, CreateEventParams> {
  final HomeRepository repository;

  CreateEventUseCase(this.repository);

  @override
  Future<Result<EventModel>> call({required CreateEventParams params}) {
    return repository.createEvent(params: params);
  }
}
