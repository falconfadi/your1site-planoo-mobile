import 'package:carousel_slider/carousel_slider.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagesSliderWidget extends StatefulWidget {

  final List<String> imgList;

  const ImagesSliderWidget({super.key,required this.imgList});

  @override
  State<ImagesSliderWidget> createState() => _CenterImagesViewState();
}

class _CenterImagesViewState extends State<ImagesSliderWidget> {

  CarouselSliderController carouselController = CarouselSliderController();
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    carouselController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: carouselController,
          options: CarouselOptions(
            height: 1.sh * 0.4,
            autoPlay: true,
            enlargeCenterPage: false,
            viewportFraction: 1,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            autoPlayInterval: const Duration(seconds: 2),
            onPageChanged: (index2, reason) {
              setState(() {
                _activeIndex = index2;
              });
            },
          ),
          itemCount: widget.imgList.length,
          itemBuilder: (BuildContext context, int photoIndex, int realIndex) {
            return CachedImage(
              imageUrl: widget.imgList[photoIndex].toString(),
              fit: BoxFit.cover,
              width: 1.sw,
            );
          },
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.imgList.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _activeIndex == index ? 15.w : 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: _activeIndex == index ? AppColors.primaryColor : AppColors.grayColor,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}