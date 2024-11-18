import 'package:cetapil_mobile/model/activity.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/activity.dart';


class ActivityController extends GetxController {
  RxList<Activity> activity = <Activity>[].obs;
  RxString searchQuery = ''.obs;
  final selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with dummy data
    activity.addAll([
      Activity(
        name: 'Guardian Setiabudi Building',
        category: 'GT',
        date: 'Senin, 01/11/2024',
      ),
      Activity(
        name: 'CV Jaya Makmur Sentosa',
        category: 'MT',
        date: 'Senin, 01/11/2024',
      ),
      Activity(
        name: 'Alfamart Senen Raya',
        category: 'GT',
        date: 'Senin, 01/11/2024',
      ),
      Activity(
        name: 'Alfamart Thamrin City',
        category: 'GT',
        date: 'Senin, 01/11/2024',
      ),
      Activity(
        name: 'Guardian Setiabudi Building',
        category: 'MT',
        date: 'Senin, 01/11/2024',
      ),
    ]);
  }

  List<Activity> get filteredOutlets => activity.where((outlet) {
    return outlet.name.toLowerCase().contains(searchQuery.value.toLowerCase());
  }).toList();

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}