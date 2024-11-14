import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'connectivity_controller.dart';


class GPSLocationController extends GetxController {
  final RxBool isGPSEnabled = false.obs;
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxString kecamatan = ''.obs;
  final RxString location = ''.obs;

  final RxString detailedLocation = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  StreamSubscription<Position>? _positionStream;
  Timer? _backupTimer;

  final ConnectivityController _connectivityController = Get.find<ConnectivityController>();

  @override
  void onInit() {
    super.onInit();
    _checkGPSStatus();
  }

  @override
  void onClose() {
    _positionStream?.cancel();
    _backupTimer?.cancel();
    super.onClose();
  }

  Future<void> _checkGPSStatus() async {
    print("Checking GPS status...");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("GPS service enabled: $serviceEnabled");
    isGPSEnabled.value = serviceEnabled;

    if (serviceEnabled) {
      _startLocationUpdates();
    }

    if (!kIsWeb) {
      Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
        print("GPS service status changed: $status");
        isGPSEnabled.value = (status == ServiceStatus.enabled);
        if (isGPSEnabled.value) {
          _startLocationUpdates();
        } else {
          _stopLocationUpdates();
          currentPosition.value = null;
          kecamatan.value = '';
          location.value = '';
        }
      });
    }
  }

  void _startLocationUpdates() {
    _positionStream?.cancel();
    _backupTimer?.cancel();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(
          (Position position) {
        print("Received position: ${position.latitude}, ${position.longitude}");
        currentPosition.value = position;
        getLocationInfo(position.latitude, position.longitude);
      },
      onError: (error) {
        print("Error in position stream: $error");
        if (error is LocationServiceDisabledException) {
          isGPSEnabled.value = false;
          currentPosition.value = null;
          kecamatan.value = '';
          location.value = '';
        }
        errorMessage.value = 'Error getting location: $error';
      },
    );

    // Backup timer to update location every 10 seconds if stream doesn't provide updates
    _backupTimer = Timer.periodic(const Duration(seconds: 10), (_) => _updateLocationManually());
  }

  void _stopLocationUpdates() {
    _positionStream?.cancel();
    _backupTimer?.cancel();
  }

  Future<void> _updateLocationManually() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("Manually updated position: ${position.latitude}, ${position.longitude}");
      currentPosition.value = position;
      getLocationInfo(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting manual location update: $e");
      if (e is LocationServiceDisabledException) {
        isGPSEnabled.value = false;
        currentPosition.value = null;
        kecamatan.value = '';
        location.value = '';
        _stopLocationUpdates();
      }
      errorMessage.value = 'Error getting location: $e';
    }
  }

  Future<bool> requestGPSActivation() async {
    print("Requesting GPS activation...");
    isLoading.value = true;
    errorMessage.value = '';

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (kIsWeb) {
          // For web, we can't enable GPS programmatically
          errorMessage.value = 'Please enable location services in your browser settings.';
          return false;
        } else {
          serviceEnabled = await Geolocator.openLocationSettings();
          if (!serviceEnabled) {
            print("Failed to enable GPS service");
            errorMessage.value = 'Failed to enable GPS service';
            return false;
          }
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permission denied");
          errorMessage.value = 'Location permission denied';
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location permission denied forever");
        errorMessage.value =
        'Location permission permanently denied. Please enable it in app settings.';
        if (!kIsWeb) {
          await Geolocator.openAppSettings();
        }
        return false;
      }

      print("GPS activated successfully");
      isGPSEnabled.value = true;
      _startLocationUpdates();
      return true;
    } catch (e) {
      print("Error during GPS activation: $e");
      errorMessage.value = 'Error during GPS activation: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getLocationInfo(double lat, double lon) async {
    if (_connectivityController.isConnected) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          kecamatan.value = place.locality ?? '';
          location.value =
          '${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';

          List<String> detailParts = [
            if (place.street != null && place.street!.isNotEmpty) place.street!,
            if (place.subLocality != null && place.subLocality!.isNotEmpty) place.subLocality!,
            if (place.locality != null && place.locality!.isNotEmpty) place.locality!,
            if (place.postalCode != null && place.postalCode!.isNotEmpty) place.postalCode!,
            if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty)
              place.administrativeArea!,
            if (place.country != null && place.country!.isNotEmpty) place.country!,
          ];
          detailedLocation.value = detailParts.join(', ');
        } else {
          _resetLocationInfo();
          errorMessage.value = 'No location information found';
        }
      } catch (e) {
        print("Error getting location info: $e");
        _resetLocationInfo();
        errorMessage.value = 'Error getting location info: $e';
      }
    } else {
      _resetLocationInfo();
      errorMessage.value = 'No internet connection';
    }
  }

  Future<String> getLocationInfoKecamatan(double lat, double lon) async {
    if (_connectivityController.isConnected) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          return place.locality ?? '';
        } else {
          _resetLocationInfo();
          errorMessage.value = 'No location information found';
          return "";
        }
      } catch (e) {
        print("Error getting location info: $e");
        return "";
      }
    } else {
      _resetLocationInfo();
      errorMessage.value = 'No internet connection';
      return "";
    }
  }

  Future<String> getLocationInfoDetailAlamat(double lat, double lon) async {
    if (_connectivityController.isConnected) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];

          List<String> detailParts = [
            if (place.street != null && place.street!.isNotEmpty) place.street!,
            if (place.subLocality != null && place.subLocality!.isNotEmpty) place.subLocality!,
            if (place.locality != null && place.locality!.isNotEmpty) place.locality!,
            if (place.postalCode != null && place.postalCode!.isNotEmpty) place.postalCode!,
            if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty)
              place.administrativeArea!,
            if (place.country != null && place.country!.isNotEmpty) place.country!,
          ];
          return detailParts.join(', ');
        } else {
          _resetLocationInfo();
          errorMessage.value = 'No location information found';
          return "";
        }
      } catch (e) {
        print("Error getting location info: $e");
        return "";
      }
    } else {
      _resetLocationInfo();
      errorMessage.value = 'No internet connection';
      return "";
    }
  }

  void _resetLocationInfo() {
    kecamatan.value = '';
    location.value = '';
    detailedLocation.value = '';
  }

  Future<String> getLocationName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String subLocality = place.subLocality ?? '';
        String locality = place.locality ?? '';
        String administrativeArea = place.administrativeArea ?? '';
        String country = place.country ?? '';

        return [subLocality, locality, administrativeArea, country]
            .where((element) => element.isNotEmpty)
            .join(', ');
      } else {
        return 'Unknown location';
      }
    } catch (e) {
      print("Error getting location info: $e");
      return 'Error: Unable to get location name';
    }
  }
}