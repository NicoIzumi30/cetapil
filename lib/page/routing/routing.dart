import 'package:cetapil_mobile/controller/routing/routing_controller.dart';
import 'package:cetapil_mobile/model/list_routing_response.dart';
import 'package:cetapil_mobile/page/routing/detail_routing.dart';
import 'package:cetapil_mobile/page/routing/list_tambah_routing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/routing/tambah_routing_controller.dart';
import '../../model/activity.dart';
import '../../model/outlet_example.dart';
import '../../utils/colors.dart';
import '../activity/tambah_activity.dart';

class RoutingPage extends GetView<RoutingController> {
  const RoutingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: SearchBar(
                  controller: TextEditingController(),
                  onChanged: controller.updateSearchQuery,
                  leading: const Icon(Icons.search),
                  hintText: 'Masukkan Kata Kunci',
                  hintStyle: WidgetStatePropertyAll(
                    TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Obx(() {
                  // Check loading state
                  // if (controller.isLoading.value) {
                  //   return const Center(child: CircularProgressIndicator());
                  // }

                  // Get the list safely
                  List<Data> outletList = controller.filteredOutlets.toList();

                  // Check empty state
                  if (outletList.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await controller.initGetRouting();
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: outletList.length,
                      itemBuilder: (context, index) {
                        // Get the routing data safely
                        Data? routing = outletList[index];

                        if (routing == null) {
                          return const SizedBox.shrink();
                        }

                        // Get sales activity safely
                        final salesActivity = routing.salesActivity;
                        bool? checkInStatus;

                        if (salesActivity != null) {
                          if (salesActivity.checkedIn != null) {
                            checkInStatus = true;
                          } else if (salesActivity.checkedOut != null) {
                            checkInStatus = false;
                          }
                        }

                        return ActivityCard(
                          routing: routing,
                          statusDraft: 'Drafted',
                          statusCheckin: checkInStatus,
                          ontap: () {
                            Get.to(() => DetailRouting(routing));
                          },
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => ListTambahRouting(), binding: TambahRoutingBinding());
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.initGetRouting();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 100),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.route_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada Routing',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
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
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final RoutingController controller = Get.find<RoutingController>();
  final Data routing;
  final String statusDraft;
  final bool? statusCheckin;
  final VoidCallback ontap;

  ActivityCard({
    Key? key,
    required this.routing,
    required this.ontap,
    required this.statusDraft,
    this.statusCheckin,
  }) : super(key: key);

  String convertTime(String? time) {
    if (time != null && time.isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(time);
        return DateFormat('HH:mm').format(dateTime);
      } catch (e) {
        print('Error parsing time: $e');
        return "";
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final salesActivity = routing.salesActivity;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFFFFF),
            Color(0x80FFFFFF),
          ],
        ),
      ),
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
                      routing.name ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black, fontSize: 13),
                        children: <TextSpan>[
                          const TextSpan(text: 'Kategori Outlet : '),
                          TextSpan(
                            text: routing.category ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Check In", style: TextStyle(fontSize: 12)),
                        Text("Check Out", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: const [
                        Text(" : ", style: TextStyle(fontSize: 12)),
                        Text(" : ", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          convertTime(salesActivity?.checkedIn),
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          convertTime(salesActivity?.checkedOut),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (statusCheckin != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 7,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: statusCheckin! ? Colors.white : AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: statusCheckin!
                                ? const [Color(0X9039B5FF), Color(0X5039B5FF)]
                                : const [Color(0X905FF95F), Color(0X501BE86E)],
                          ),
                        ),
                        child: Text(
                          statusCheckin! ? "Check-In" : "Check-Out",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: ontap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        minimumSize: const Size(80, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'Lihat',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
