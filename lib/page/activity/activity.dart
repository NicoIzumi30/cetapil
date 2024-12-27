import 'package:cetapil_mobile/controller/activity/detail_activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/knowledge_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_availibility_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_order_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_visibility_controller.dart';
import 'package:cetapil_mobile/page/activity/detail_activity.dart';
import 'package:cetapil_mobile/page/activity/tambah_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../controller/activity/activity_controller.dart';
import '../../database/activity_database.dart';
import '../../model/activity.dart';
import '../../model/list_activity_response.dart';
import '../../utils/colors.dart';
import '../outlet/detail_outlet.dart';

class ActivityPage extends GetView<ActivityController> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: SearchBar(
                controller: TextEditingController(),
                onChanged: controller.updateSearchQuery,
                leading: const Icon(Icons.search),
                hintText: 'Masukkan Kata Kunci',
                hintStyle: WidgetStatePropertyAll(TextStyle(color: Colors.grey[500], fontSize: 14)),
                shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Obx(
                () => RefreshIndicator(
                  onRefresh: () async {
                    await controller.initGetActivity();
                  },
                  child: controller.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : controller.filteredActivities.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              itemCount: controller.filteredActivities.length,
                              itemBuilder: (context, index) {
                                final activity =
                                    controller.filteredActivities[index];
                                return ActivityCard(
                                  activity: activity,
                                  statusDraft: activity.status!,
                                  statusCheckin: true,
                                  ontap: () async {
                                    // Get.delete<TambahActivityController>();
                                    // if (!Get.isRegistered<TambahActivityController>()) {
                                    //   Get.lazyPut(()=>TambahActivityController());
                                    // }
                                    // if (!Get.isRegistered<DetailActivityController>()) {
                                    //   Get.lazyPut(()=>DetailActivityController());
                                    // }
                                    if (!Get.isRegistered<TambahAvailabilityController>()) {
                                      Get.lazyPut(() => TambahAvailabilityController());
                                    }
                                    if (!Get.isRegistered<TambahVisibilityController>()) {
                                      Get.lazyPut(() => TambahVisibilityController());
                                    }
                                    if (!Get.isRegistered<TambahOrderController>()) {
                                      Get.lazyPut(() => TambahOrderController());
                                    }
                                    if (!Get.isRegistered<KnowledgeController>()) {
                                      Get.lazyPut(() => KnowledgeController());
                                    }
                                    if (activity.status! == "SUBMITTED") {
                                      if (!Get.isRegistered<DetailActivityController>()) {
                                        Get.lazyPut(() => DetailActivityController());
                                      }
                                      final detailActivityController =
                                          Get.find<DetailActivityController>();
                                      detailActivityController.selectedTab.value = 0;
                                      detailActivityController.visibilityItems.clear();
                                      detailActivityController.setDetailOutlet(activity);
                                      Get.to(() => DetailActivity(activity.id!));
                                    } else if (activity.status! == "DRAFTED") {
                                      if (!Get.isRegistered<TambahActivityController>()) {
                                        Get.lazyPut(() => TambahActivityController());
                                      }
                                      final dbActivity = ActivityDatabaseHelper.instance;
                                      final tambahActivityController = Get.find<TambahActivityController>();
                                      var fetchedData = await dbActivity.getDetailSalesActivity(activity.id!);
                                      tambahActivityController.selectedTab.value = 0;
                                      tambahActivityController.detailDraft.assignAll(fetchedData!);
                                      tambahActivityController.startTabTimer();
                                      tambahActivityController.setDetailOutlet(activity);
                                      tambahActivityController.initDetailDraftAvailability();
                                      tambahActivityController.initDetailDraftVisibility();
                                      // tambahActivityController.initDetailDraftOrder();
                                      Get.to(() => TambahActivity());
                                    }
                                    else{
                                      if (!Get.isRegistered<TambahActivityController>()) {
                                        Get.lazyPut(()=>TambahActivityController());
                                      }
                                      final tambahActivityController =
                                          Get.find<TambahActivityController>();
                                      final outlet_id = activity.outlet!.id;
                                      tambahActivityController.selectedTab.value = 0;
                                      tambahActivityController.startTabTimer();
                                      tambahActivityController.clearAllDraftItems();
                                      tambahActivityController.setOutletId(outlet_id!);
                                      tambahActivityController.setDetailOutlet(activity);
                                      Get.to(() => TambahActivity());
                                    }

                                  },
                                );
                              },
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildEmptyState() {
    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 100),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icon/Vector3.svg",
                height: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Tidak ada Activity',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Tarik ke bawah untuk memuat data',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Data activity;
  final String statusDraft;
  final bool statusCheckin;
  final VoidCallback ontap;

  const ActivityCard({
    Key? key,
    required this.activity,
    required this.ontap,
    required this.statusDraft,
    required this.statusCheckin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFFF),
                Color(0x80FFFFFF),
              ])),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.outlet!.name!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                        text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 13),
                      children: <TextSpan>[
                        TextSpan(text: 'Kategori Outlet : '),
                        TextSpan(
                          text: activity.outlet!.category,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                  ],
                ),
                // Text("Senin/12",style: TextStyle(fontSize: 11,fontStyle: FontStyle.italic),)
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  decoration: BoxDecoration(
                    color: statusDraft == "DRAFTED"
                        ? Colors.white
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusDraft.replaceAll(RegExp('_'), ' '),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusDraft == "DRAFTED"
                            ? Colors.blue
                            : Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                      decoration: BoxDecoration(
                          color:
                          statusDraft == "SUBMITTED" ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors:  statusDraft == "SUBMITTED"
                                  ? [Color(0X905FF95F), Color(0X501BE86E)]
                                  : [Color(0X9039B5FF), Color(0X5039B5FF)])),
                      child: Text(
                          statusDraft == "SUBMITTED" ? "Check-Out" : "Check-In",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: ontap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],

                        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                        minimumSize: const Size(80, 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: const Text(
                        'Lihat',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
