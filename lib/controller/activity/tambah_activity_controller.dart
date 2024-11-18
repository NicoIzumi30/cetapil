import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TambahActivityController extends GetxController {
  final TextEditingController controller = TextEditingController();
  final selectedTab = 0.obs;


  void changeTab(int index) {
    selectedTab.value = index;
    update();
  }

  /// Survey Section
  var switchValue = true.obs;

  void setSwitchValue(bool value) {
    switchValue.value = value;
  }


  /// Order Section

}