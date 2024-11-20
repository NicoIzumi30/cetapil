import 'package:cetapil_mobile/controller/routing/routing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                      () => ListView.builder(
                    itemCount: controller.filteredOutlets.length,
                    itemBuilder: (context, index) {
                      final outlet = controller.filteredOutlets[index];
                      return ActivityCard(outlet: outlet, statusDraft: 'Drafted',statusCheckin: true, ontap: (){
                        Get.to(()=> TambahActivity());
                      },);
                    },
                  ),
                ),
              ),
            ])));
  }
}

class ActivityCard extends StatelessWidget {
  final RoutingController controller = Get.find<RoutingController>();
  final Outlet outlet;
  final String statusDraft;
  final bool statusCheckin;
  final VoidCallback ontap;

   ActivityCard({
    Key? key,
    required this.outlet, required this.ontap, required this.statusDraft, required this.statusCheckin,
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
                      outlet.outletName,
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
                              text: outlet.category,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ],
                ),
                Text(controller.formatDate(outlet.createdAt),style: TextStyle(fontSize: 11,fontStyle: FontStyle.italic),)
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),

                  decoration: BoxDecoration(
                    color: statusDraft == "Drafted" ? Colors.white : AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusDraft,
                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold, color: statusDraft == "Drafted" ? Colors.blue : Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                      decoration: BoxDecoration(
                          color: statusCheckin ? Colors.white : AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors:
                              statusCheckin
                                  ? [
                                Color(0X9039B5FF),
                                Color(0X5039B5FF)
                              ]
                                  : [
                                Color(0X905FF95F),
                                Color(0X501BE86E)
                              ]

                          )
                      ),
                      child: Text(
                        statusCheckin ? "Check-In" : "Check-Out",
                        style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                    SizedBox(width: 10,),
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