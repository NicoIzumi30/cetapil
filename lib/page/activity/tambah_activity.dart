import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/availability.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/knowledge.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/order.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/survey.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/visibility.dart';
import 'package:cetapil_mobile/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/back_button.dart';
import '../outlet/detail_outlet.dart';

class TambahActivity extends GetView<TambahActivityController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  // Get.back();
                  Navigator.of(context).pop();
                },
                backgroundColor: Colors.white,
                iconColor: Colors.blue,
              ),
              SizedBox(
                height: 20,
              ),
              UnderlineTextField.readOnly(
                title: "Nama Outlet",
                value: "Guardian Setiabudi Building",
              ),
              UnderlineTextField.readOnly(
                title: "Kategori Outlet",
                value: "MT",
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
            ],
          ))
    ]));
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
            buildTab(0, "Availability"),
            buildTab(1, "Visibility"),
            buildTab(2, "Knowledge"),
            buildTab(3, "Survey"),
            buildTab(4, "Order"),
          ],
        ),
      ),
    );
  }

  Widget buildTab(int index, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTabChanged(index);
        },
        child: Container(
          decoration: BoxDecoration(color: selectedIndex == index ? Colors.blue : Colors.white),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 11, color: selectedIndex == index ? Colors.white : Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
