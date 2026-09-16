import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
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
import 'package:geolocator/geolocator.dart' as geolocator;

class CreateLocationScreen extends StatefulWidget {

  final String? ownerType;
  final String? ownerId;
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
  LatLng initialPosition = const LatLng(0, 0);
  bool _isPositionInitialized = false;

  geolocator.Position _pickPosition = geolocator.Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 0.0,headingAccuracy: 0.0);

  Location location = Location();
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    if (widget.location != null && widget.location!.lat != null && widget.location!.long != null) {
      initialPosition = LatLng(
        widget.location!.lat!.toDouble(),
        widget.location!.long!.toDouble(),
      );
      _setupPositions(initialPosition);
    } else {
      getCurrentLocation();
    }
  }

  void _setupPositions(LatLng targetPosition) {
    _cameraPosition = CameraPosition(target: targetPosition, zoom: 16);
    _pickPosition = geolocator.Position(
      latitude: targetPosition.latitude,
      longitude: targetPosition.longitude,
      timestamp: DateTime.now(),
      accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
      altitudeAccuracy: 0.0, headingAccuracy: 0.0,
    );
    _isPositionInitialized = true;
  }

  Future<void> getCurrentLocation() async {
    setState(() {
      _searchLoading = true;
    });

    bool serviceEnabled;

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          setState(() {
            _searchLoading = false;
          });
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          _exitLoadingWithError();
          return;
        }
      }

      await location.changeSettings(accuracy: LocationAccuracy.high);
      locationData = await location.getLocation();

      if (locationData != null && locationData!.latitude != null && locationData!.longitude != null) {
        initialPosition = LatLng(locationData!.latitude!, locationData!.longitude!);
        _setupPositions(initialPosition);

        if (_mapController != null && _cameraPosition != null) {
          _mapController!.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
        }
      }
    } catch(e) {
      debugPrint("Error fetching location: $e");
    }

    setState(() => _searchLoading = false);
  }

  void _exitLoadingWithError() {
    setState(() {
      _searchLoading = false;
    });
  }

  void updatePosition(CameraPosition position) {
    _pickPosition = geolocator.Position(
      latitude: position.target.latitude,
      longitude: position.target.longitude,
      timestamp: DateTime.now(),
      accuracy: 1, altitude: 1, heading: 1,
      speedAccuracy: 1, speed: 1,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  LocationModel _buildResultLocation() {
    return LocationModel(
      iD: widget.location?.iD,
      lat: _pickPosition.latitude,
      long: _pickPosition.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    if (_searchLoading && !_isPositionInitialized) {
      return const Scaffold(body: Center(child: LoadingIndicator()));
    }
    return Scaffold(
      body: SafeArea(
          child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialPosition,
                    zoom: 16,
                  ),
                  minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController mapController) {
                    _mapController = mapController;
                  },
                  onCameraMove: (CameraPosition cameraPosition) {
                    _cameraPosition = cameraPosition;
                    updatePosition(cameraPosition);
                  },
                ),
                Center(child: Padding(
                  padding: EdgeInsets.only(bottom: 25.h),
                  child: Icon(Icons.location_on,size: isTablet ? 80 : 50,color: AppColors.redColor),
                )),
                Positioned(
                    bottom: 20.h,
                    left: 20.w,
                    right: 20.w,
                    child: CreateModel(
                      withValidation: false,
                      onTap: () {},
                      onSuccess: (data) {
                        Navigation.pop(
                          value: _buildResultLocation(),
                        );
                      },
                      useCaseCallBack: (model) {
                        return EditLocationUseCase(HomeRepository()).call(
                            params: EditLocationParams(
                              ownerType: widget.ownerType!,
                              ownerId: widget.ownerId!,
                              locationId: widget.location!.iD!,
                              lat: _pickPosition.latitude,
                              long: _pickPosition.longitude,
                            ));
                      },
                      child: CustomButton(
                        backgroundColor: AppColors.primaryColor,
                        borderRadius: 10.r,
                        buttonName: AppLocalization.of(context).translate(widget.isEdit == true ? "edit": "pick_location"),
                        function: widget.isEdit == true ? null : () {
                          Navigation.pop(
                            value: _buildResultLocation(),
                          );
                        },
                      ),
                    )
                ),
              ]
          )
      )
    );
  }
}