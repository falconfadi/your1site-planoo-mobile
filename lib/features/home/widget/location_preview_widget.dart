import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/features/home/data/model/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPreviewWidget extends StatelessWidget {

  final LocationModel? location;
  final VoidCallback onTap;

  const LocationPreviewWidget({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: location == null ? null : 120.h,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: location == null ? CustomContainerInfoWidget(
          title: AppLocalization.of(context).translate("location"),
        ) : IgnorePointer(
          child: GoogleMap(
            key: ValueKey("${location!.lat}_${location!.long}"),
            initialCameraPosition: CameraPosition(
              target: LatLng(location!.lat!, location!.long!),
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('location'),
                position: LatLng(
                  location!.lat!,
                  location!.long!,
                ),
              ),
            },
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
          ),
        ),
      ),
    );
  }
}