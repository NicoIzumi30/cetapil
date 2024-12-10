import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_availibility_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_detail_page/availability.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_detail_page/visibility.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/availability.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/knowledge.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/order.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/survey.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/visibility.dart';
import 'package:cetapil_mobile/page/activity/tambah_activity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api.dart';
import '../../controller/activity/activity_controller.dart';
import '../../controller/activity/detail_activity_controller.dart';
import '../../controller/support_data_controller.dart';
import '../../model/detail_activity_response.dart';
import '../../utils/colors.dart';
import '../../widget/back_button.dart';
import '../../widget/dialog.dart';
import '../outlet/detail_outlet.dart';

class DetailActivity extends GetView<DetailActivityController> {
  const DetailActivity(this.activityId, {super.key});
  final String activityId;

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
                  Alerts.showConfirmDialog(
                    context,
                    onContinue: () async {
                      Get.back();
                    },
                  );
                },
                backgroundColor: Colors.white,
                iconColor: Colors.blue,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: FutureBuilder(
                  future: Api.getDetailActivity(activityId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return buildDetailPage(data);
                    }
                
                    return Center(child: Text('No data available'));
                  },
                ),
              ),
            ],
          ))
    ]));
  }

  Column buildDetailPage(DetailActivityResponse snapshot) {
    final detailActivityController = Get.find<DetailActivityController>();
    final tambahAvailabilityController = Get.find<TambahAvailabilityController>();
    late SupportDataController supportController = Get.find<SupportDataController>();
    final allVisibilities = controller.detailOutlet.value!.visibilities ?? [];

    detailActivityController.availabilityDraftItems.value = snapshot.data?.availabilities?.map((item) => {
      'id': item.id,
      'sku': tambahAvailabilityController.getSkuByDataApi(item.productId!)!['sku'],
      'category': tambahAvailabilityController.getSkuByDataApi(item.productId!)!['category']['name'],
      'stock': item.availabilityStock,
      'av3m': item.averageStock,
      'recommend': item.idealStock,
    }).toList() ?? [];
    tambahAvailabilityController.clearForm();

    if (snapshot.data!.visibilities!.isNotEmpty) {
      for(var dataApi in allVisibilities) {
        for (var item in snapshot.data!.visibilities!) {
          final posmType = supportController
              .getPosmTypes()
              .firstWhereOrNull((posm) => posm['id'] == dataApi.posmTypeId);
          final visualType = supportController
              .getVisualTypes()
              .firstWhereOrNull((visual) =>
          visual['id'] == dataApi.visualTypeId);
          final newItem = {
            'id': item.id,
            'posm_type_id': dataApi.posmTypeId,
            'posm_type_name': posmType!['name'],
            'visual_type_id': dataApi.visualTypeId,
            'visual_type_name': visualType!['name'],
            'condition': item.condition,
            'planogram': dataApi.image,
            'image1': item.path1,
            'image2': item.path2,
          };
          detailActivityController.visibilityDraftItems.add(newItem);
        }
      }
    }
    // detailActivityController.visibilityDraftItems.value = snapshot.data?.visibilities?.map((item) => {
    //   'id': item.id,
    //   'posm_type_id': dataApi.posmTypeId,
    //   'posm_type_name': posmType!['name'],
    //   'visual_type_id': dataApi.visualTypeId,
    //   'visual_type_name': visualType!['name'],
    //   'condition': item.condition,
    //   'image1': item.path1,
    //   'image2': item.path2,
    // }).toList() ?? [];




    return Column(
      children: [
        UnderlineTextField.readOnly(
          title: "Nama Outlet",
          value: snapshot.data!.outlet!.name,
        ),
        UnderlineTextField.readOnly(
          title: "Kategori Outlet",
          value: snapshot.data!.outlet!.category,
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
                  return DetailAvailabilityPage();
                case 1:
                  return DetailVisibilityPage();
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
                  true,
                  "Kembali",
                      () => Get.back()
                ),
              ],
            ),
          ),
        ),
      ],
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
