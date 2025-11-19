import 'dart:io';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/media_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CreateMediaParams extends BaseParams {

  final String ownerType;
  final int ownerId;
  final File file;

  CreateMediaParams({
    required this.ownerType,
    required this.ownerId,
    required this.file
  });

  Map<String, dynamic> toJson() {
    return {
      'type': "image",
      "media[][name]": "",
    };
  }
}

class CreateMediaUseCase extends UseCase<AllMediasModel, CreateMediaParams> {
  final HomeRepository repository;

  CreateMediaUseCase(this.repository);

  @override
  Future<Result<AllMediasModel>> call({required CreateMediaParams params}) {
    return repository.createMedia(params: params);
  }
}
