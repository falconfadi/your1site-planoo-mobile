import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/location_model.dart';
import 'package:centro_partner/features/home/data/usecase/location/edit_location_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/loading.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:geolocator/geolocator.dart';

class CreateLocationScreen extends StatefulWidget {

  final String? ownerType;
  final int? ownerId;
  final LocationModel? location;
  final bool? isEdit;

  const CreateLocationScreen({super.key,this.ownerType,this.ownerId,this.location,this.isEdit});

  @override
  State<CreateLocationScreen> createState() => _CreateLocationScreenState();
}

class _CreateLocationScreenState extends State<CreateLocationScreen> {

  bool _searchLoading = false;
  LocationData? locationData;
  CameraPosition? _cameraPosition;
  LatLng? initialPosition;
  bool isLoading = false;
  Position _pickPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 0.0,headingAccuracy: 0.0);
  Location location = Location();

  @override
  void initState() {
    super.initState();
    if (widget.location != null) {
      initialPosition = LatLng(
        widget.location!.lat!.toDouble(),
        widget.location!.long!.toDouble(),
      );
      _pickPosition = Position(
        latitude: initialPosition!.latitude,
        longitude: initialPosition!.longitude,
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
      _searchLoading = false;
      setState(() {});
    } else {
      getCurrentLocation();
    }
  }

  Future<void> getCurrentLocation() async {
    _searchLoading = true;
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    if (locationData != null) {
      initialPosition = LatLng(
        locationData!.latitude!.toDouble(),
        locationData!.longitude!.toDouble(),
      );
    }
    _searchLoading = false;
    setState(() {});
  }

  void updatePosition(CameraPosition position, bool fromAddress) {
    try {
      _pickPosition = Position(
        altitudeAccuracy: 0,headingAccuracy: 0,
        latitude: position.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
        heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
      );
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: SizedBox(
                width: 1.sw,
                child: !_searchLoading ? Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: initialPosition ?? const LatLng(0, 0),
                          zoom: 16,
                        ),
                        minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                        myLocationButtonEnabled: false,
                        onMapCreated: (GoogleMapController mapController) {
                          mapController = mapController;
                        },
                        zoomControlsEnabled: false,
                        onCameraMove: (CameraPosition cameraPosition) {
                          _cameraPosition = cameraPosition;
                        },
                        onCameraIdle: () {
                          updatePosition(_cameraPosition!, false);
                        },
                      ),
                      const Center(child: Icon(Icons.location_on,size: 50,color: Colors.red)),
                      Positioned(
                        bottom: 20.h,
                        left: 20.w,
                        right: 20.w,
                        child: CreateModel(
                          withValidation: false,
                          onTap: () {},
                          onSuccess: (data) {
                            Navigation.pop(value: LocationModel(
                              lat: _pickPosition.latitude == 0.0 ? locationData?.latitude ?? widget.location!.lat! : _pickPosition.latitude,
                              long: _pickPosition.longitude == 0.0 ? locationData?.longitude ?? widget.location!.long! : _pickPosition.longitude,
                              ),
                            );
                          },
                          useCaseCallBack: (model) {
                            return EditLocationUseCase(HomeRepository()).call(
                                params: EditLocationParams(
                                  ownerType: widget.ownerType!,
                                  ownerId: widget.ownerId!,
                                  locationId: widget.location!.iD!,
                                  lat: widget.location!.lat!,
                                  long: widget.location!.long!,
                                ));
                          },
                          child: CustomButton(
                            backgroundColor: AppColors.primaryColor,
                            borderRadius: 10.r,
                            buttonName: AppLocalization.of(context).translate(widget.isEdit == true ? "edit": "pick_location"),
                            function: widget.isEdit == true ? null : () {
                              Navigation.pop(value: LocationModel(
                                lat: _pickPosition.latitude == 0.0 ? locationData!.latitude! : _pickPosition.latitude,
                                long: _pickPosition.longitude == 0.0 ? locationData!.longitude! : _pickPosition.longitude,
                              ));
                            },
                          ),
                        )
                      ),
                    ]) :
                const Center(
                  child: LoadingIndicator(),
                )
              )
          )
      ),
    );
  }
}
