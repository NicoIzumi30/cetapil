import 'package:cetapil_mobile/model/activity.dart';
import 'package:cetapil_mobile/model/list_activity_response.dart';
import 'package:cetapil_mobile/widget/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../api/api.dart';
import '../../database/activity_database.dart';
import '../../database/database_instance.dart';
import '../../model/activity.dart';

class ActivityController extends GetxController {
  RxList<Data> activity = <Data>[].obs;
  final db = DatabaseHelper.instance;
  final dbActivity = ActivityDatabaseHelper.instance;
  RxString searchQuery = ''.obs;
  final selectedTab = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initGetActivity();
  }

  initGetActivity() async {
    try {
      await db.deleteAllActivity();
      activity.clear();

      CustomAlerts.showLoading(Get.context!, "Processing", "Mengambil data aktivitas...");

      final response = await Api.getActivityList();
      if (response.status == "OK" && response.data!.isNotEmpty) {
        for (int i = 0; i < response.data!.length; i++) {
          final result = response.data![i];
          Map<String, dynamic> data = {
            'id': result.id,
            'checked_in': result.checkedIn,
            'checked_out': result.checkedOut,
            'channel_id': result.channel?.id,
            'channel_name': result.channel?.name,
            'views_knowledge': result.viewsKnowledge,
            'time_availability': result.timeAvailability,
            'time_visibility': result.timeVisibility,
            'time_knowledge': result.timeKnowledge,
            'time_survey': result.timeSurvey,
            'time_order': result.timeOrder,
            'status': result.status,
          };

          if (result.outlet != null) {
            data.addAll({
              'outlet_id': result.outlet!.id,
              'name': result.outlet!.name,
              'category': result.outlet!.category,
              'city_id': result.outlet!.cityId,
              'longitude': result.outlet!.longitude,
              'latitude': result.outlet!.latitude,
              'visit_day': result.outlet!.visitDay,
            });
          }

          if (result.visibilities != null) {
            data['visibilities'] = result.visibilities!
                .map((v) => {
              'id': v.id,
              'posm_type_id': v.posmTypeId,
              'visual_type_id': v.visualTypeId,
              'filename': v.filename,
              'image': v.image,
            })
                .toList();
          }

          await db.insertActivity(data);
        }

        final apiDraft = await db.getSalesActivities();
        final localDraftIds = await dbActivity.getSalesActivityIds();
        print("list id : $localDraftIds");

        for (var data in apiDraft) {
          print("data api : ${localDraftIds.contains(data.id)}");
          if (localDraftIds.contains(data.id)) {
            /// UBAH STATUS MENJADI DRAFTED
            await db.updateSalesActivityStatus(data.id!);
          }
        }
        final result = await db.getSalesActivities();

        activity.addAll(result);

        // Dismiss loading first
        CustomAlerts.dismissLoading();

        // Show success
        CustomAlerts.showSuccess(Get.context!, "Berhasil", "Data aktivitas berhasil diperbarui");
      }
    } catch (e) {
      print('Error saving Activity: $e');

      // Dismiss loading
      CustomAlerts.dismissLoading();

      // Show error
      CustomAlerts.showError(
          Get.context!, "Gagal", "Gagal mengambil data: Periksa koneksi Anda dan coba lagi");
    } finally {
      CustomAlerts.dismissLoading();
    }
    // try {
    //   activity.clear();
    //
    //   CustomAlerts.showLoading(
    //       Get.context!, "Processing", "Mengambil data aktivitas...");
    //
    //   final response = await Api.getActivityList();
    //   if (response.status == "OK" && response.data!.isNotEmpty) {
    //     for (int i = 0; i < response.data!.length; i++) {
    //       final result = response.data![i];
    //       Map<String, dynamic> data = {
    //         'sales_activity_id': result.id,
    //         'channel_id': result.channel?.id,
    //         'channel_name': result.channel?.name,
    //         'views_knowledge': result.viewsKnowledge,
    //         'time_availability': result.timeAvailability,
    //         'time_visibility': result.timeVisibility,
    //         'time_knowledge': result.timeKnowledge,
    //         'time_survey': result.timeSurvey,
    //         'time_order': result.timeOrder,
    //         'status': result.status,
    //         'checked_in': result.checkedIn,
    //         'checked_out': result.checkedOut,
    //       };
    //
    //       if (result.outlet != null) {
    //         data.addAll({
    //           'outlet_id': result.outlet!.id,
    //           'name': result.outlet!.name,
    //           'category': result.outlet!.category,
    //         });
    //       }
    //
    //       List<Map<String, dynamic>> availabilityList = [];
    //       List<Map<String, dynamic>> visibilityList = [];
    //       List<Map<String, dynamic>> surveyList = [];
    //       List<Map<String, dynamic>> orderList = [];
    //
    //
    //       await db.insertFullSalesActivity(
    //           data: data,
    //           availabilityItems: availabilityList,
    //           visibilityItems: visibilityList,
    //           surveyItems: surveyList,
    //           orderItems: orderList);
    //     }
    //
    //     final results = await db.getSalesActivities(); /// GET LIST SalesActivity
    //     activity.addAll(results);
    //
    //     // Dismiss loading first
    //     CustomAlerts.dismissLoading();
    //
    //     // Show success
    //     CustomAlerts.showSuccess(
    //         Get.context!, "Berhasil", "Data aktivitas berhasil diperbarui");
    //   }
    // } catch (e) {
    //   print('Error saving Activity: $e');
    //
    //   // Dismiss loading
    //   CustomAlerts.dismissLoading();
    //
    //   // Show error
    //   CustomAlerts.showError(Get.context!, "Gagal",
    //       "Gagal mengambil data: Periksa koneksi Anda dan coba lagi");
    // } finally {
    //   CustomAlerts.dismissLoading();
    // }
  }

  List<Data> get filteredOutlets => activity.where((outlet) {
        return outlet.outlet!.name!
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase());
      }).toList();

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}
