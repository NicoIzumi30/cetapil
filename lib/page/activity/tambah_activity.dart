import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/availability.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/knowledge.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/order.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/survey.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/visibility.dart';
import 'package:cetapil_mobile/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/list_activity_response.dart' as Activity;

import '../../widget/back_button.dart';
import '../../widget/dialog.dart';
import '../outlet/detail_outlet.dart';

class TambahActivity extends GetView<TambahActivityController> {
  TambahActivity(
    this.activity, {
    super.key,
  });
  final Activity.Data activity;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await Alerts.showConfirmDialog(context);
        return shouldPop ?? false;
      },
      child: SafeArea(
          child: Stack(children: [
        Image.asset(
          'assets/background.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EnhancedBackButton(
                  onPressed: () {
                    Alerts.showConfirmDialog(
                      context,
                      onContinue: () async {
                        Get.back();
                        final controller = Get.find<TambahActivityController>();
                        controller.clearAllDraftItems();
                        controller.onClose();
                      },
                    );
                  },
                  backgroundColor: Colors.white,
                  iconColor: Colors.blue,
                ),
                SizedBox(
                  height: 20,
                ),
                UnderlineTextField.readOnly(
                    title: "Nama Outlet",
                    value: activity.outlet!.name,
                  ),
                 UnderlineTextField.readOnly(
                    title: "Kategori Outlet",
                    value: activity.outlet!.category,
                  ),
                Obx(() {
                  return SecondaryTabbar(
                      selectedIndex: controller.selectedTab.value,
                      onTabChanged: controller.changeTab);
                }),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Obx(() {
                      switch (controller.selectedTab.value) {
                        case 0:
                          return AvailabilityPage();
                        case 1:
                          return VisibilityPage();
                        case 2:
                          return KnowledgePage();
                        case 3:
                          return SurveyPage();
                        default:
                          return OrderPage();
                      }
                    }),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      children: [
                        _buildButton(
                          false,
                          "Simpan Draft",
                          () => null,
                        ),
                        SizedBox(width: 10),
                        _buildButton(
                          true,
                          "Kirim",
                          () => controller.submitApiActivity(),
                          // controller.submitOutlet(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ))
      ])),
    );
  }

  Expanded _buildButton(bool isSubmit, String title, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSubmit ? AppColors.primary : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: isSubmit
                ? BorderSide.none
                : BorderSide(color: AppColors.primary),
          ),
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
            color: isSubmit ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class SecondaryTabbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  SecondaryTabbar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            buildTab(0, "Availability", false),
            buildTab(1, "Visibility", false),
            buildTab(2, "Knowledge", false),
            buildTab(3, "Survey", false),
            buildTab(4, "Order", false),
          ],
        ),
      ),
    );
  }

  Widget buildTab(int index, String label, bool isDisable) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          (isDisable != true) ? onTabChanged(index) : null;
        },
        child: Container(
          decoration: BoxDecoration(
              color: (isDisable == true)
                  ? Colors.grey
                  : (selectedIndex == index)
                      ? Colors.blue
                      : Colors.white),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 11,
                  color: selectedIndex == index ? Colors.white : Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
