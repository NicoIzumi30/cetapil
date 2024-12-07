import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
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
import '../../model/detail_activity_response.dart';
import '../../widget/back_button.dart';
import '../../widget/dialog.dart';
import '../outlet/detail_outlet.dart';

class DetailActivity extends GetView<ActivityController> {
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
              FutureBuilder(
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
            ],
          ))
    ]));
  }

  Column buildDetailPage(DetailActivityResponse snapshot) {
    final tambahActivityController = Get.find<TambahActivityController>();
    tambahActivityController.availabilityDraftItems.value = snapshot.data?.availabilities?.map((item) => {
      'id': item.id,
      'category': "HARDCODE",
      'sku': item.productId,
      'stock': item.availabilityStock,
      'av3m': item.availabilityStock,
      'recommend': item.idealStock,
    }).toList() ?? [];

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
    );
  }
}
