import 'package:carousel_slider/carousel_slider.dart';
import 'package:cetapil_mobile/controller/dashboard/dashboard_controller.dart';
import 'package:cetapil_mobile/page/dashboard/setting_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widget/progress_indicator.dart';

class DashboardPage extends GetView<DashboardController> {
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: RefreshIndicator(
        onRefresh: controller.onRefresh,
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
                              Text("Selphi Nusawati Indira",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.bold))
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
                          SizedBox(
                            height: 25,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20))),
                                onPressed: () {},
                                child: Text(
                                  "Checked-In",
                                  style: TextStyle(fontSize: 11),
                                )),
                          )
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
                                  "${controller.dashboard.value?.data?.region ?? ""}",
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text("Outlet", style: TextStyle(fontSize: 10, color: Colors.blue)),
                                Text(
                                    "${controller.dashboard.value?.data?.currentOutlet?.name ?? ""}",
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))
                              ],
                            ),
                            Column(
                              children: [
                                Text("Outlet Radius",
                                    style: TextStyle(fontSize: 10, color: Colors.blue)),
                                Text(
                                  "20m",
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: controller.imageUrls.length,
                  itemBuilder: (context, index, realIndex) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.asset(controller.imageUrls[index]),
                    );
                  },
                  options: CarouselOptions(
                    // aspectRatio: 3 / 2,
                    viewportFraction: 1,
                    enlargeCenterPage: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    onPageChanged: (index, reason) {
                      controller.currentIndex.value = index;
                    },
                  ),
                ),
                Obx(() {
                  return Center(
                    child: AnimatedSmoothIndicator(
                      activeIndex: controller.currentIndex.value,
                      count: controller.imageUrls.length,
                      effect: WormEffect(dotHeight: 10, dotWidth: 10),
                    ),
                  );
                }),
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
                                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Cek Kalender",
                                        style: TextStyle(
                                            color: Color(0xFF054F7B), fontWeight: FontWeight.bold),
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
                          "Update terbaru : 14 November 2024",
                          style: TextStyle(fontSize: 10),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        AnimatedGlossyProgressBar(
                          progress: (controller.dashboard.value?.data?.planPercentage ?? 0) / 100,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "*Performance index dihitung berdasarkan target call vs aktual \n call user yang telah dilakukan dalam 1 Bulan",
                          style: TextStyle(fontSize: 8),
                        ),
                      ],
                    ))
              ],
            );
          }),
        ),
      ),
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
