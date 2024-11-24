import 'package:cetapil_mobile/controller/routing/routing_controller.dart';
import 'package:cetapil_mobile/model/list_routing_response.dart';
import 'package:cetapil_mobile/page/routing/detail_routing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/activity.dart';
import '../../model/outlet_example.dart';
import '../../utils/colors.dart';
import '../activity/tambah_activity.dart';

class RoutingPage extends GetView<RoutingController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Column(children: [
              SizedBox(
                height: 40,
                child: SearchBar(
                  controller: TextEditingController(),
                  onChanged: controller.updateSearchQuery,
                  leading: const Icon(Icons.search),
                  hintText: 'Masukkan Kata Kunci',
                  hintStyle: WidgetStatePropertyAll(
                      TextStyle(color: Colors.grey[500], fontSize: 14)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Obx(
                  () => RefreshIndicator(
                      onRefresh: () async {
                        await controller.initGetRouting();
                      },
                      child: controller.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : controller.filteredOutlets.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: controller.filteredOutlets.length,
                                  itemBuilder: (context, index) {
                                    final routing =
                                        controller.filteredOutlets[index];
                                    print("ada cekin : ${routing.salesActivity!.checkedIn}");
                                    final checkin = routing.salesActivity!.checkedIn;
                                    final checkout = routing.salesActivity!.checkedOut;

                                    return ActivityCard(
                                      routing: routing,
                                      statusDraft: 'Drafted',
                                      statusCheckin: (checkin != null ) ? true : (checkout != null) ? false : null,
                                      ontap: () {
                                        Get.to(() => DetailRouting(routing));
                                      },
                                    );
                                  },
                                )),
                ),
              )
            ])));
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
              Icon(
                Icons.route_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Tidak ada Routing',
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

  convertTime(String time){
    if (time.isNotEmpty || time != "") {
      DateTime dateTime = DateTime.parse(time);

      // Format to "HH:mm"
      String formattedTime = DateFormat('HH:mm').format(dateTime);
      return formattedTime;
    }
    return "";

  }

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
                      routing.name!,
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
                          text: routing.category,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                  ],
                ),
                // Text(controller.formatDate(routing.visitDay!),style: TextStyle(fontSize: 11,fontStyle: FontStyle.italic),)
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Check In",style: TextStyle(fontSize: 12),),
                        Text("Check Out",style: TextStyle(fontSize: 12),),
                      ],
                    ),
                    Column(
                      children: [
                        Text(" : ",style: TextStyle(fontSize: 12),),
                        Text(" : ",style: TextStyle(fontSize: 12),),
                      ],
                    ),
                    Column(
                      children: [
                        Text(convertTime(routing.salesActivity!.checkedIn ?? ""),style: TextStyle(fontSize: 12),),
                        Text(convertTime(routing.salesActivity!.checkedOut ?? ""),style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ],
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                //   decoration: BoxDecoration(
                //     color: statusDraft == "Drafted"
                //         ? Colors.white
                //         : AppColors.primary,
                //     borderRadius: BorderRadius.circular(4),
                //   ),
                //   child: Text(
                //     statusDraft,
                //     style: TextStyle(
                //         fontSize: 12,
                //         fontWeight: FontWeight.bold,
                //         color: statusDraft == "Drafted"
                //             ? Colors.blue
                //             : Colors.white),
                //   ),
                // ),
                
                Row(
                  children: [
                    statusCheckin != null
                    ? Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                      decoration: BoxDecoration(
                          color:
                              statusCheckin! ? Colors.white : AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: statusCheckin!
                                  ? [Color(0X9039B5FF), Color(0X5039B5FF)]
                                  : [Color(0X905FF95F), Color(0X501BE86E)])),
                      child: Text(
                        statusCheckin! ? "Check-In" : "Check-Out",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                    )
                    : SizedBox(),
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
