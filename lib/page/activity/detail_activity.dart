import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_availibility_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_order_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_detail_page/availability.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_detail_page/order.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_detail_page/survey.dart';
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
    final tambahActivityController = Get.find<TambahActivityController>();
    final tambahOrderController = Get.find<TambahOrderController>();
    late SupportDataController supportController = Get.find<SupportDataController>();
    final allVisibilities = [];

    /// AVAILABILITY SECTION
    detailActivityController.availabilityDetailItems.value = snapshot.data?.availabilities?.map((item) => {
      'id': item.id,
      'product_id': item.productId!,
      'category': item.category,
      'sku': item.sku,
      'availability_exist': item.availability == "Y" ? true : false,
      'stock_on_hand': item.stockOnHand,
      'stock_on_inventory': item.stockInventory,
      'av3m': item.av3m,
      'recommend': item.rekomendasi,
    }).toList() ?? [];
    // tambahAvailabilityController.clearForm();

    ///VISIBILITY SECTION
    detailActivityController.visibilityPrimaryDetailItems.addAll(snapshot.data?.visibilities?.primary?.map((item) => {
      'id': "primary-${item.category!.toLowerCase()}-${item.position}",
      'category': item.category,
      'position': item.position,
      'posm_type_id': item.posmType?.id,
      'posm_type_name': item.posmType?.name,
      'visual_type_id': item.visualType, /// DUMMY ID
      'visual_type_name': item.visualType,
      'condition': item.condition,
      'shelf_width': item.shelfWidth,
      'shelving': item.shelving,
      'image_visibility': item.displayPhoto,
    }).toList() ?? []);

    detailActivityController.visibilitySecondaryDetailItems.addAll(snapshot.data?.visibilities?.secondary?.map((item) => {
      'id': "secondary-${item.category!.toLowerCase()}-${item.position}",
      'category': item.category,
      'position': item.position,
      'secondary_exist': item.hasSecondaryDisplay,
      'display_type': item.visualType,
      'display_image': item.displayPhoto,
    }).toList() ?? []);

    detailActivityController.visibilityKompetitorDetailItems.addAll(snapshot.data?.visibilities?.competitor?.map((item) => {
      'id': "kompetitor-kompetitor-${item.position}",
      'category': item.category,
      'position': item.position,
      'brand_name': item.competitorBrandName,
      'promo_mechanism': item.competitorPromoMechanism,
      'promo_periode_start': item.competitorPromoStart, /// GANTI JADI VISUALTYPE ID
      'promo_periode_end': item.competitorPromoEnd,
      'program_image1': item.displayPhoto,
      'program_image2': item.displayPhoto2,
    }).toList() ?? []);

    ///ORDER SECTION
    detailActivityController.orderDetailItems.value = snapshot.data?.orders?.map((item) => {
      'id': item.id,
      'product_id': item.productId!,
      'category': item.category,
      'sku': item.sku,
      'jumlah': item.totalItems,
      'harga': item.subtotal,
    }).toList() ?? [];
    // tambahAvailabilityController.clearForm();


    ///SURVEY SECTION
    detailActivityController.surveyDetailItems.value = snapshot.data?.surveys?.map((item) => {
      "id" : item.id,
      "sales_activity_id": item.salesActivityId,
      "survey_question_id": item.surveyQuestionId,
      "answer": item.answer,
    } ).toList() ?? [];


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
              controller: tambahActivityController,
              onTabChanged: controller.changeTab,

          );
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
                  return DetailSurveyPage();
                default:
                  return DetailOrderPage();
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

class SecondaryTabbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;
  final TambahActivityController? controller;

  SecondaryTabbar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChanged, this.controller,
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
          )
      ),
    );
  }

  Widget buildTab(int index, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {onTabChanged(index);
        },
        child: Container(
          decoration: BoxDecoration(
              color: (selectedIndex == index)
                  ? Colors.blue
                  : Colors.white ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 11,
                  color: (selectedIndex == index) ? Colors.white : Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}