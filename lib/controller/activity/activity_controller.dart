import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:cetapil_mobile/database/database_instance.dart';
import 'package:cetapil_mobile/model/list_activity_response.dart';
import 'package:cetapil_mobile/widget/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api.dart';
import '../../database/activity_database.dart';
import '../../model/list_activity_response.dart' as Activity;

class ActivityController extends GetxController {
  RxList<Activity.Data> activity = <Activity.Data>[].obs;
  final supportController = Get.find<SupportDataController>();
  final db = DatabaseHelper.instance;
  final dbActivity = ActivityDatabaseHelper.instance;
  RxString searchQuery = ''.obs;
  final selectedTab = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLocalData();
  }

  void changeTab(int index) {
    selectedTab.value = index;
    update();
  }

  Future<void> loadLocalData() async {
    try {
      final results = await db.getSalesActivities();
      activity.clear();
      activity.addAll(results);

      if (activity.isEmpty) {
        await initGetActivity();
      }
    } catch (e) {
      print('Error loading local data: $e');
    }
  }

  Future<void> initGetActivity({draftRefresh = false}) async {
    try {
      activity.clear();

      CustomAlerts.showLoading(Get.context!, "Processing", "Mengambil data aktivitas...");

      // Refresh support data first
      if (draftRefresh == false) {
        await supportController.refreshData();

        final response = await Api.getActivityList();
        if (response.status == "OK") {
          // Clear all existing activities first
          await db.deleteAllActivity();

          if (response.data != null && response.data!.isNotEmpty) {
            // Insert new activities from API
            for (var result in response.data!) {
              Map<String, dynamic> data = {
                'id': result.id,
                'user': result.user != null
                    ? {
                        'id': result.user!.id,
                        'name': result.user!.name,
                      }
                    : null,
                'channel': result.channel != null
                    ? {
                        'id': result.channel!.id,
                        'name': result.channel!.name,
                      }
                    : null,
                'checked_in': result.checkedIn,
                'checked_out': result.checkedOut,
                'views_knowledge': result.viewsKnowledge,
                'time_availability': result.timeAvailability,
                'time_visibility': result.timeVisibility,
                'time_knowledge': result.timeKnowledge,
                'time_survey': result.timeSurvey,
                'time_order': result.timeOrder,
                'status': result.status,
              };

              if (result.outlet != null) {
                data['outlet'] = {
                  'id': result.outlet!.id,
                  'name': result.outlet!.name,
                  'category': result.outlet!.category,
                  'city_id': result.outlet!.cityId,
                  'longitude': result.outlet!.longitude,
                  'latitude': result.outlet!.latitude,
                  'visit_day': result.outlet!.visitDay,
                };
              }

              if (result.av3mProducts != null && result.av3mProducts!.isNotEmpty) {
                data['av3m_products'] = result.av3mProducts!
                    .map((product) => {
                          'product_id': product.productId,
                          'av3m': product.av3M,
                        })
                    .toList();
              }

              await db.insertActivity(data);
            }
          }

          CustomAlerts.dismissLoading();
          CustomAlerts.showSuccess(Get.context!, "Berhasil", "Data aktivitas berhasil diperbarui");
        }
      }

      // Get local draft IDs if you're still handling drafts
      final localDraftIds = await dbActivity.getDraftActivityIds();

      // Update any activities that have local drafts
      for (String id in localDraftIds) {
        // Check if the activity still exists in the API response
        final activityExists = await dbActivity.getActivityById(id) != null;
        if (activityExists) {
          await db.updateSalesActivityStatus(id);
        } else {
          // If activity no longer exists in API, remove the draft
          await dbActivity.deleteDraft(id);
        }
      }

      // Reload all activities from local database
      final results = await db.getSalesActivities();
      activity.addAll(results);
    } catch (e) {
      print('Error saving Activity: $e');
      CustomAlerts.dismissLoading();
      CustomAlerts.showError(
          Get.context!, "Gagal", "Gagal mengambil data: Periksa koneksi Anda dan coba lagi");
    } finally {
      CustomAlerts.dismissLoading();
    }
  }

  List<Activity.Data> get filteredActivities => activity.where((activity) {
        if (activity.outlet == null) return false;
        return activity.outlet!.name!.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  Future<void> refreshActivities() async {
    isLoading.value = true;
    try {
      await initGetActivity();
    } finally {
      isLoading.value = false;
    }
  }
}
