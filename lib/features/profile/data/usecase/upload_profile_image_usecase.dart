import 'dart:io';
import 'package:centro_partner/features/profile/data/model/profile_image_model.dart';
import 'package:centro_partner/features/profile/data/profile_repository/profile_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class UploadProfileImageParams extends BaseParams {

  final File file;

  UploadProfileImageParams({required this.file});

}

class UploadProfileImageUseCase extends UseCase<ProfileImageModel, UploadProfileImageParams> {
  final ProfileRepository repository;

  UploadProfileImageUseCase(this.repository);

  @override
  Future<Result<ProfileImageModel>> call({required UploadProfileImageParams params}) {
    return repository.uploadProfileImage(params: params);
  }
}
