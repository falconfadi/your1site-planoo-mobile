import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocode/geocode.dart' as locator;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class CreateLocationScreen extends StatefulWidget {

  bool? isEdit;

  CreateLocationScreen({this.isEdit = false,super.key});

  @override
  State<CreateLocationScreen> createState() => _CreateLocationScreenState();
}

class _CreateLocationScreenState extends State<CreateLocationScreen> {

  bool _searchLoading = false;
  LocationData? locationData;
  GoogleMapController? mapController;
  CameraPosition? _cameraPosition;
  LatLng? _initialPosition;
  bool isLoading = false;
  Position _pickPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 0.0,headingAccuracy: 0.0);
  String locationTitle = "";
  Location location = Location();

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
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
      _initialPosition = LatLng(
        locationData!.latitude!.toDouble(),
        locationData!.longitude!.toDouble(),
      );
    }
    _searchLoading = false;
    setState(() {});
  }

  void updatePosition(CameraPosition position, bool fromAddress) async {
    isLoading = true;
    setState(() {});
    try {
      _pickPosition = Position(
        altitudeAccuracy: 0,headingAccuracy: 0,
        latitude: position.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
        heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
      );
      setState(() {});
    } catch (e) {}
    isLoading = false;
    setState(() {});
  }

  Future<String> getLocationTitle(double? lat, double? lang) async {
    try {
      isLoading = true;
      setState(() {});

      if (lat == null || lang == null) return "";

      locator.GeoCode geoCode = locator.GeoCode();
      locator.Address address = await geoCode.reverseGeocoding(latitude: lat, longitude: lang);

      final combined = "${address.streetAddress}, ${address.region}";

      // Check if geocode.xyz returned a throttling message
      if (combined.contains("Throttled!")) {
        locationTitle = "";
      } else {
        locationTitle = combined;
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading = false;
      setState(() {});
    }

    return locationTitle;
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
                          target: LatLng(
                            locationData!.latitude!,
                            locationData!.longitude!,
                          ),
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
                        child: !isLoading ? CustomButton(
                          width: 1.sw * 0.9,
                          backgroundColor: AppColors.primaryColor,
                          borderRadius: 8.r,
                          buttonName: AppLocalization.of(context).translate("pick_location"),
                          function: () {
                            getLocationTitle(_pickPosition.latitude == 0.0 ?
                            locationData!.latitude : _pickPosition.latitude,
                                _pickPosition.longitude == 0.0 ? locationData!.longitude : _pickPosition.longitude
                            ).then((value) {
                              // todo make a set or edit location api
                            });
                          },
                        ) : const Center(child: LoadingIndicator()),
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
