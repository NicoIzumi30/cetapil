import 'package:cetapil_mobile/page/selling/detail_selling.dart';
import 'package:cetapil_mobile/page/selling/tambah_selling.dart';
import 'package:cetapil_mobile/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/selling/selling_controller.dart';
// import '../../model/outlet.dart';
import '../../model/outlet_example.dart';
import '../outlet/outlet.dart';

class SellingPage extends GetView<SellingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
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
                  hintStyle:
                      WidgetStatePropertyAll(TextStyle(color: Colors.grey[500], fontSize: 14)),
                  shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
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
                      return SellingCard(
                          ontap: () {
                            Get.to(() => DetailSelling());
                          },
                          status: "Terkirim",
                          outlet: outlet);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clearForm(); // Clear the form first
          Get.to(() => TambahSelling());
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class SellingCard extends StatelessWidget {
  final String status;
  final Outlet outlet;
  final VoidCallback ontap;

  const SellingCard({
    Key? key,
    required this.outlet,
    required this.status,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient:
              LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
            Color(0xFFFFFFFF),
            Color(0x80FFFFFF),
          ])),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
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
                ),
                const SizedBox(width: 16),
                Text(
                  "Senin, 01/11/2024",
                  style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  decoration: BoxDecoration(
                    color: status == "Drafted" ? Colors.white : AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: status == "Drafted" ? Colors.blue : Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: ontap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],

                    // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                    minimumSize: const Size(80, 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text(
                    'Lihat',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: const Size(80, 26),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      child: const Text(
        'Drafted',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
