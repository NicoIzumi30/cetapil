import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cetapil_mobile/controller/dashboard/dashboard_controller.dart';
import 'package:cetapil_mobile/controller/login_controller.dart';
import 'package:cetapil_mobile/model/dashboard.dart';
import 'package:cetapil_mobile/page/dashboard/setting_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../widget/progress_indicator.dart';

class DashboardPage extends GetView<DashboardController> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  DashboardPage() {
    final loginController = Get.find<LoginController>();
    // Ensure controller is initialized
    if (loginController.currentUser.value != null) {
      if (!Get.isRegistered<DashboardController>()) {
        Get.put(DashboardController());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (loginController) {
      // Only proceed if user is logged in
      if (loginController.currentUser.value == null) {
        return Container(); // Or a loading widget
      }
      return Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: RefreshIndicator(
          onRefresh: () async {
            // Ensure controller exists and handle refresh
            final dashboardController = Get.find<DashboardController>();
            await dashboardController.onRefresh();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(), // Add this line
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Selamat Datang",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF0077BD),
                                        fontWeight: FontWeight.bold)),
                                Obx(() {
                                  return Text(controller.username.value,
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Color(0xFFFFFFFF),
                                          fontWeight: FontWeight.bold));
                                })
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(SettingProfile());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                                decoration: BoxDecoration(
                                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: SvgPicture.asset('assets/icon/setting_account.svg'),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 25,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20))),
                                  onPressed: () {},
                                  child: Text(
                                    "${controller.dashboard.value?.data?.role ?? ""}",
                                    style: TextStyle(fontSize: 11),
                                  )),
                            ),
                            controller.dashboard.value?.data?.currentOutlet?.checkedIn != null
                                ? SizedBox(
                                    height: 25,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20))),
                                        onPressed: () {},
                                        child: Text(
                                          "Check-in",
                                          style: TextStyle(fontSize: 11),
                                        )),
                                  )
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10), color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Cluster Region",
                                    style: TextStyle(fontSize: 10, color: Colors.blue),
                                  ),
                                  Text(
                                    "${controller.dashboard.value?.data?.region ?? "-"}",
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text("Outlet",
                                      style: TextStyle(fontSize: 10, color: Colors.blue)),
                                  Text(
                                      "${controller.dashboard.value?.data?.currentOutlet?.name ?? "-"}",
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))
                                ],
                              ),
                              Column(
                                children: [
                                  Text("Outlet Radius",
                                      style: TextStyle(fontSize: 10, color: Colors.blue)),
                                  Obx(() => Text(
                                        controller.outletDistance.value,
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Obx(() {
                      print(controller.programUrls.length);
                      if (controller.programUrls.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          CarouselSlider.builder(
                            carouselController: _carouselController,
                            itemCount: controller.programUrls.length,
                            itemBuilder: (context, index, realIndex) {
                              final program = controller.programUrls[index];
                              final imageUrl =
                                  'https://dev-cetaphil.i-am.host/storage${program.path ?? ''}';

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                  cacheManager: DefaultCacheManager(),
                                  cacheKey: program.filename,
                                ),
                              );
                            },
                            options: CarouselOptions(
                              viewportFraction: 1,
                              enlargeCenterPage: false,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              onPageChanged: (index, reason) {
                                controller.currentIndex.value = index;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Center(
                              child: AnimatedSmoothIndicator(
                                activeIndex: controller.currentIndex.value,
                                count: controller.programUrls.length,
                                effect: WormEffect(dotHeight: 10, dotWidth: 10),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  Stack(
                    alignment: Alignment(1, 1),
                    children: [
                      Container(
                        width: double.infinity,
                        // height: 80,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Color(0xFF39B5FF), // Lighter blue at top
                              // Color(0xFF9BD8F1), // Darker blue at bottom
                              Color(0xFFB2E6FD), // Darker blue at bottom
                            ],
                          ),
                          boxShadow: [
                            // Top light shadow
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              offset: const Offset(0, -1),
                              blurRadius: 4,
                            ),
                            // Bottom shadow
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Obx(() => Text(
                                      controller.getIndonesianDay(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )),
                                Obx(() => Text(
                                      controller.currentDate.value.day.toString(),
                                      style: TextStyle(
                                        fontSize: 55,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        height: 1,
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                GestureDetector(
                                  onTap: () => controller.showCustomCalendarDialog(context),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Cek Kalender",
                                          style: TextStyle(
                                              color: Color(0xFF054F7B),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(Icons.calendar_month_rounded, color: Color(0xFF054F7B))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Obx(() => Text(
                                      "${controller.getIndonesianMonth()} ${controller.currentDate.value.year}",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // SvgPicture.asset('assets/vector_calendar.svg'),
                            Image.asset('assets/vector_calendar.png')
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      itemSummary(
                        title: "Call Plan",
                        value: "${controller.dashboard.value?.data?.totalCallPlan ?? ""}",
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      itemSummary(
                        title: "Actual Plan",
                        value: "${controller.dashboard.value?.data?.totalActualPlan ?? ""}",
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      itemSummary(
                        title: "Outlet Coverage",
                        value: "${controller.dashboard.value?.data?.totalOutlet ?? ""}",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Performance Index",
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 20, color: Color(0xFF054F7B)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFFFFFF), // Lighter blue at top
                              // Color(0xFF9BD8F1), // Darker blue at bottom
                              Color(0x80FFFFFF), // Darker blue at bottom
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Update terbaru: ${controller.dashboard.value?.data?.lastPerformanceUpdate ?? '-'}",
                            style: TextStyle(fontSize: 10),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          AnimatedGlossyProgressBar(
                            progress: (controller.dashboard.value?.data?.planPercentage ?? 0) / 100,
                            // progress: 0,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "*Performance index dihitung berdasarkan target call vs aktual \n call user yang telah dilakukan dalam 1 Hari",
                            style: TextStyle(fontSize: 8),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  PowerSkuSection(
                    powerSkus: controller.dashboard.value?.data?.powerSkus,
                    lastUpdate: controller.dashboard.value?.data?.lastPowerSkuUpdate,
                  ),
                ],
              );
            }),
          ),
        ),
      );
    });
  }
}

class PowerSkuSection extends StatelessWidget {
  final List<PowerSkus>? powerSkus;
  final String? lastUpdate;

  const PowerSkuSection({
    Key? key,
    required this.powerSkus,
    this.lastUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Power SKU Index",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: Color(0xFF054F7B),
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update terbaru: ${lastUpdate ?? DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                style: TextStyle(fontSize: 10),
              ),
              SizedBox(height: 10),
              if (powerSkus != null && powerSkus!.isNotEmpty)
                ...powerSkus!.map((sku) => PowerSkuItem(
                      skuName: sku.sku ?? '',
                      progress: (sku.availabilityPercentage ?? 0)/100,
                    )),
              if (powerSkus == null || powerSkus!.isEmpty)
                Center(
                  child: Text(
                    'No Power SKU data available',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              SizedBox(height: 15),
              Text(
                "*Power SKU Index dihitung dari jumlah suatu produk pada\nOutlet Coverage",
                style: TextStyle(fontSize: 8),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PowerSkuItem extends StatelessWidget {
  final String skuName;
  final double progress;

  const PowerSkuItem({
    Key? key,
    required this.skuName,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          skuName,
          style: TextStyle(fontSize: 11),
        ),
        SizedBox(height: 4),
        Container(
          height: 20,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade200,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    width: constraints.maxWidth * progress,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF39B5FF),
                          Color(0xFF9BD8F1),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 2,
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        color: progress > 0.5 ? Colors.white : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

class itemSummary extends StatelessWidget {
  final String title;
  final String value;

  const itemSummary({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFFFFF), // Lighter blue at top
                // Color(0xFF9BD8F1), // Darker blue at bottom
                Color(0x80FFFFFF), // Darker blue at bottom
              ],
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.blue)),
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            )
          ],
        ),
      ),
    );
  }
}
