import 'dart:async';

import 'package:cetapil_mobile/controller/gps_controller.dart';
import 'package:cetapil_mobile/controller/outlet/outlet_controller.dart';
import 'package:cetapil_mobile/model/list_routing_response.dart';
import 'package:cetapil_mobile/widget/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../api/api.dart';
import '../../database/database_instance.dart';
import '../support_data_controller.dart';

class RoutingController extends GetxController {
  // SECTION: Dependencies
  final OutletController _outletController = Get.find<OutletController>();
  final SupportDataController _supportController = Get.find<SupportDataController>();
  final GPSLocationController _gpsController = Get.find<GPSLocationController>();
  final DatabaseHelper _db = DatabaseHelper.instance;
  final Uuid _uuid = Uuid();

  // Getters for dependencies
  OutletController get outletController => _outletController;
  SupportDataController get supportController => _supportController;
  DatabaseHelper get db => _db;

  // SECTION: Observable States
  final RxString searchQuery = ''.obs;
  final RxList<Data> routing = <Data>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await loadLocalData();
  }

  // SECTION: Data Loading
  Future<void> loadLocalData() async {
    try {
      isLoading.value = true;

      final results = await _db.getAllRouting();
      routing.clear();
      routing.addAll(results);

      if (routing.isEmpty) {
        await refreshRoutingData();
      }
    } catch (e) {
      print('Error loading local data: $e');
      _handleError('Gagal memuat data lokal: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshRoutingData() async {
    try {
      isSyncing.value = true;
      // CustomAlerts.showLoading(Get.context!, "Processing", "Mengambil data routing...");

      await _clearExistingData();
      final response = await _fetchRoutingData().timeout(
        Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('API timeout'),
      );
      await _processRoutingData(response);

      CustomAlerts.dismissLoading();
      CustomAlerts.showSuccess(Get.context!, "Berhasil", "Data routing berhasil diperbarui");
    } on TimeoutException catch (e) {
      print("error $e");
      CustomAlerts.dismissLoading();
        _handleError('Gagal mengambil data: Periksa koneksi Anda dan coba lagi');
    }
    finally {
      isSyncing.value = false;
      CustomAlerts.dismissLoading();
    }
  }

  Future<void> _clearExistingData() async {
    await _db.deleteAllRouting();
    routing.clear();
  }

  Future<ListRoutingResponse> _fetchRoutingData() async {
    final response = await Api.getRoutingList();
    if (response.status != "OK") {
      throw 'Failed to get routing data from server';
    }
    return response;
  }

  Future<void> _processRoutingData(ListRoutingResponse response) async {
    if (response.data == null || response.data!.isEmpty) return;

    for (final result in response.data!) {
      final data = _prepareRoutingData(result);
      await _db.insertRoutingWithAnswers(data: data);
    }

    final results = await _db.getAllRouting();
    routing.addAll(results);
  }

  Map<String, dynamic> _prepareRoutingData(Data result) {
    final data = {
      'id': result.id,
      'outletName': result.name ?? "",
      'salesName': result.user?.name ?? "",
      'category': result.category ?? "",
      'city_id': result.city?.id ?? "",
      'city_name': result.city?.name ?? "",
      'longitude': double.tryParse(result.longitude ?? "") ?? 0.0,
      'latitude': double.tryParse(result.latitude ?? "") ?? 0.0,
      'address': result.address ?? "",
      'status_outlet': result.status ?? "",
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    _addSalesActivityData(data, result);
    _addImagesData(data, result);
    _addFormsData(data, result);

    return data;
  }

  void _addSalesActivityData(Map<String, dynamic> data, Data result) {
    if (result.salesActivity != null) {
      data.addAll({
        'activities_id': _uuid.v4(),
        'outlet_id': result.id,
        'user_id': result.user?.id ?? "",
        'checked_in': result.salesActivity?.checkedIn,
        'checked_out': result.salesActivity?.checkedOut,
        'views_knowledge': 0,
        'time_availability': 0,
        'time_visibility': 0,
        'time_knowledge': 0,
        'time_survey': 0,
        'time_order': 0,
        'status_activities': result.salesActivity?.status ?? "PENDING",
      });
    }
  }

  void _addImagesData(Map<String, dynamic> data, Data result) {
    if (result.images != null) {
      for (int i = 0; i < 3; i++) {
        data['image_path_${i + 1}'] =
            i < result.images!.length ? result.images![i].image ?? "" : "";
      }
    }
  }

  void _addFormsData(Map<String, dynamic> data, Data result) {
    if (result.forms != null && result.forms!.isNotEmpty) {
      final formAnswers = Map.fromEntries(
          result.forms!.map((form) => MapEntry(form.outletForm?.id ?? "", form.answer ?? "")));

      for (final formData in _supportController.getFormOutlet()) {
        final questionId = formData['id'];
        data['form_id_$questionId'] = formAnswers[questionId] ?? "";
      }
    }
  }

  // SECTION: Check-in Operations
  Future<void> submitCheckin(String outletId) async {
    try {
      // Check if GPS is enabled
      if (!_gpsController.isGPSEnabled.value) {
        bool gpsActivated = await _gpsController.requestGPSActivation();
        if (!gpsActivated) {
          throw 'Please enable GPS to check in';
        }
      }

      // Get current position
      Position? position = _gpsController.currentPosition.value;
      if (position == null) {
        throw 'Unable to get current location. Please try again';
      }

      // Ensure we have a valid context before showing loading
      final context = Get.context;
      if (context == null) {
        throw 'Invalid context state';
      }

      // Show loading with null check and mounted check
      if (context.mounted) {
        CustomAlerts.showLoading(context, "Check in", "Check in data routing...");
      }

      try {
        final data = {
          'outlet_id': outletId,
          'checked_in': DateTime.now().toIso8601String(),
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        };

        final response = await Api.submitCheckin(data);

        // Ensure context is still valid before dismissing
        if (Get.context != null && Get.context!.mounted) {
          CustomAlerts.dismissLoading();
        }

        if (response.status != "OK") {
          throw 'Gagal melakukan check in';
        }

        // Get location name for success message
        String locationName = await _gpsController.getLocationName(
          position.latitude,
          position.longitude,
        );

        Get.back();

        await _clearExistingData();
        final responses = await _fetchRoutingData();
        await _processRoutingData(responses);

        final outletName = routing.firstWhere((r) => r.id == outletId).name;

        // Final check before showing success message
        if (Get.context != null && Get.context!.mounted) {
          CustomAlerts.showSuccess(
              Get.context!, "Check in", "Berhasil Check in di $outletName\nLokasi: $locationName");
        }
      } finally {
        // Ensure loading is dismissed even if an error occurs
        if (Get.context != null && Get.context!.mounted) {
          CustomAlerts.dismissLoading();
        }
      }
    } catch (e) {
      // Ensure loading is dismissed before showing error
      if (Get.context != null && Get.context!.mounted) {
        CustomAlerts.dismissLoading();
      }
      _handleError('Gagal melakukan check in: $e');
    }
  }

  // SECTION: Utility Methods
  bool isRoutingActive(String outletId) {
    final routingData = routing.firstWhereOrNull((r) => r.id == outletId);
    if (routingData?.salesActivity != null) {
      return routingData!.salesActivity!.checkedIn != null ||
          routingData.salesActivity!.checkedOut != null;
    }
    return false;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  String formatDate(DateTime now) {
    return DateFormat('EEEE, dd/MM/yyyy').format(now);
  }

  List<Data> get filteredOutlets => routing.where((routing) {
        return routing.name!.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();

  void _handleError(String message) {
    print('Error: $message');
    CustomAlerts.dismissLoading();
    CustomAlerts.showError(Get.context!, "Gagal", message);
  }
}
