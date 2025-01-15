import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/cache_controller.dart';
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
  @override
  Widget build(BuildContext context) {
    final detailDraft = controller.detailDraft;
    final detailApi = controller.detailOutlet;

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await Alerts.showConfirmDialog(context);
        if (shouldPop == true && controller.selectedTab.value == 2) {
          Get.delete<CachedVideoController>();
          Get.delete<CachedPdfController>();
        }
        return shouldPop ?? false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,

          // Wrap with Scaffold for proper layout
          body: Stack(
            children: [
              // Background
              Image.asset(
                'assets/background.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),

              // Main Content
              Column(
                children: [
                  // Fixed Header Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Important!
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
                        SizedBox(height: 20),
                        UnderlineTextField.readOnly(
                          title: "Nama Outlet",
                          value: detailDraft.isNotEmpty
                              ? detailDraft['name']
                              : detailApi.value!.outlet!.name,
                        ),
                        UnderlineTextField.readOnly(
                          title: "Kategori Outlet",
                          value: detailDraft.isNotEmpty
                              ? detailDraft['category']
                              : detailApi.value!.outlet!.category,
                        ),
                        Obx(() {
                          return SecondaryTabbar(
                            selectedIndex: controller.selectedTab.value,
                            onTabChanged: controller.changeTab,
                            controller: controller,
                          );
                        }),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),

                  // Scrollable Content Section
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Obx(() {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Tab content
                              _buildTabContent(controller.selectedTab.value),
                              // Add bottom padding for scroll space
                              SizedBox(height: 80), // Space for bottom buttons
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),

              // Fixed Bottom Buttons
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      _buildButton(
                        false,
                        "Simpan Draft",
                        () => controller.saveDraftActivity(),
                      ),
                      SizedBox(width: 10),
                      _buildButton(
                        true,
                        "Kirim",
                        () => controller.submitApiActivity(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(int selectedTab) {
    switch (selectedTab) {
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
  }

  Expanded _buildButton(bool isSubmit, String title, VoidCallback onTap) {
    return Expanded(
      child: GetBuilder<TambahActivityController>(
        builder: (controller) {
          final bool isEnabled = !isSubmit || controller.canSubmitState;

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isSubmit ? (isEnabled ? AppColors.primary : Colors.grey) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: isSubmit ? BorderSide.none : BorderSide(color: AppColors.primary),
              ),
            ),
            onPressed: isEnabled ? onTap : null,
            child: Text(
              title,
              style: TextStyle(
                color: isSubmit ? (isEnabled ? Colors.white : Colors.white70) : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}

class SecondaryTabbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;
  final TambahActivityController? controller;

  SecondaryTabbar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChanged,
    this.controller,
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
        child: Obx(() {
          return Row(
            children: [
              buildTab(0, "Availability", controller!.disableSecondaryTab(0)),
              buildTab(1, "Visibility", controller!.disableSecondaryTab(1)),
              buildTab(2, "Knowledge", controller!.disableSecondaryTab(2)),
              buildTab(3, "Survey", controller!.disableSecondaryTab(3)),
              buildTab(4, "Order", controller!.disableSecondaryTab(4)),
            ],
          );
        }),
      ),
    );
  }

  Widget buildTab(int index, String label, bool isEnable) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          isEnable ? onTabChanged(index) : null;
        },
        child: Container(
          decoration: BoxDecoration(
              color: !isEnable
                  ? Colors.grey
                  : (selectedIndex == index)
                      ? Colors.blue
                      : Colors.white),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 11,
                  color: !isEnable
                      ? Colors.white
                      : (selectedIndex == index)
                          ? Colors.white
                          : Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
