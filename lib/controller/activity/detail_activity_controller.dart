
import 'package:flutter/material.dart';

import '../../model/list_activity_response.dart' as Activity;
import 'package:get/get.dart';


class DetailActivityController extends GetxController {
  Rx<Activity.Data?> detailOutlet = Rx<Activity.Data?>(null);
  final selectedTab = 0.obs;

  void changeTab(int index) {
    selectedTab.value = index;
    update();
  }

  setDetailOutlet(Activity.Data data) {
    detailOutlet.value = data;
    print(detailOutlet.value);
  }

  final Map<String, TextEditingController> priceControllers = {};
  final Map<String, RxBool> switchStates = {};

  bool getSwitchValue(String id) {
    return switchStates[id]?.value ?? true;
  }

  void toggleSwitch(String id, bool value) {
    final switchValue = switchStates[id];
    if (switchValue != null) {
      switchValue.value = value;
    }
  }

  final availabilitItems = <Map<String, dynamic>>[].obs;
  final orderItems = <Map<String, dynamic>>[].obs;
  final visibilityItems = <Map<String, dynamic>>[].obs;
  final surveyItems = <Map<String, dynamic>>[].obs;
}