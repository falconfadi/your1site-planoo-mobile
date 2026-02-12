import 'dart:io';
import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/media_model.dart';
import 'package:centro_partner/features/home/data/usecase/media/all_medias_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/media/create_media_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/media/delete_medial_usecase.dart';
import 'package:centro_partner/core/ui/shared_widgets/view_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class PhotosWidget extends StatefulWidget {

  final String? ownerType;
  final int? ownerId;
  final List<File> photos;
  final bool? isEdit;

  const PhotosWidget({super.key,this.ownerType,this.ownerId,required this.photos,this.isEdit});

  @override
  State<PhotosWidget> createState() => _PhotosWidgetState();
}

class _PhotosWidgetState extends State<PhotosWidget> {

  GetModelCubit<AllMediasModel>? refreshCubit;
  File? selectedFile;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          CreateModel(
            withValidation: false,
            onTap: () {},
            onSuccess: (model) async {
              refreshCubit!.getModel();
            },
            useCaseCallBack: (model) async {
              await selectImage();
              return CreateMediaUseCase(HomeRepository()).call(
                  params: CreateMediaParams(
                      ownerType: widget.ownerType!,
                      ownerId: widget.ownerId!, file: selectedFile!
                  )
              );
            },
            child: InkWell(
              onTap: widget.isEdit == true ? null : () => selectImage(),
              child: CustomContainerInfoWidget(title:AppLocalization.of(context).translate("photos"),
              ),
            ),
          ),
          SizedBox(height: widget.photos.isEmpty ? 0 : 20.h),
          widget.photos.isEmpty ? const Center() :
          Container(
            height: 100.w,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.photos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Stack(
                    children: [
                      ViewImageWidget(
                        width: 100.w,
                        height: 100.w,
                        isFile: true,
                        file: widget.photos[index],
                      ),
                      Positioned(
                        top: 5.h,
                        right: 5.w,
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                widget.photos.removeAt(index);
                              });
                            },
                            child: SvgPicture.asset(delete,width: 24.w,color: AppColors.redColor,)
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: widget.photos.isEmpty ? 0 : 20.h),
          if(widget.isEdit == true)
            GetModel<AllMediasModel>(
              loadingHeight: 30.h,
              onCubitCreated: (cubit) {
                refreshCubit = cubit as GetModelCubit<AllMediasModel>;
              },
              useCaseCallBack: () {
                return AllMediasUseCase(HomeRepository()).call(
                    params: AllMediasParams(
                        ownerType: widget.ownerType!,
                        ownerId: widget.ownerId!
                    ));
              },
              modelBuilder: (getModel) => Container(
                height: 100.w,
                margin: EdgeInsets.symmetric(horizontal: 5.w,vertical: 10.h),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: getModel.mediaList!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Stack(
                        children: [
                          ViewImageWidget(
                            width: 100.w,
                            height: 100.w,
                            image: getModel.mediaList![index].url!,
                          ),
                          Positioned(
                              top: 5.h,
                              right: 5.w,
                              child: CreateModel(
                                withValidation: false,
                                onTap: () {},
                                onSuccess: (data) {
                                  refreshCubit!.getModel();
                                },
                                useCaseCallBack: (model) {
                                  return DeleteMediaUseCase(HomeRepository()).call(
                                      params: DeleteMediaParams(
                                          ownerType: widget.ownerType!,
                                          ownerId: widget.ownerId!,
                                          mediaId: getModel.mediaList![index].id!
                                      )
                                  );
                                },
                                child: SvgPicture.asset(delete,width: 24.w,color: AppColors.redColor),
                              )
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> selectImage() async {
    final imagePicker = ImagePicker();
    if (widget.isEdit == true) {
      final XFile? picked = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (picked != null) {
        File original = File(picked.path);
        File? compressed = await compressAndResizeImage(original);
        if (compressed != null) {
          selectedFile = compressed;
        }
      }
    } else {
      final List<XFile> result = await imagePicker.pickMultiImage(imageQuality: 100);
      if (result.isNotEmpty) {
        List<File> compressedFiles = [];
        for (final image in result) {
          File original = File(image.path);
          File? compressed = compressAndResizeImage(original);
          if (compressed != null) {
            compressedFiles.add(compressed);
          }
        }
        setState(() {
          widget.photos.addAll(compressedFiles);
        });
      }
    }
  }

  File compressAndResizeImage(File file) {
    img.Image? image = img.decodeImage(file.readAsBytesSync());
    int width;
    int height;

    if (image!.width > image.height) {
      width = 800;
      height = (image.height / image.width * 800).round();
    } else {
      height = 800;
      width = (image.width / image.height * 800).round();
    }

    img.Image resizedImage = img.copyResize(image, width: width, height: height);
    List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 85);

    File compressedFile = File(file.path.replaceFirst('.jpg', '_compressed.jpg'));
    compressedFile.writeAsBytesSync(compressedBytes);
    return compressedFile;
  }

}
