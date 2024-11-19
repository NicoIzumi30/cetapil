import 'package:cetapil_mobile/controller/outlet/outlet_controller.dart';
import 'package:cetapil_mobile/model/outlet.dart';
import 'package:cetapil_mobile/page/outlet/detail_outlet.dart';
import 'package:cetapil_mobile/page/outlet/tambah_outlet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/outlet_example.dart';

class OutletPage extends GetView<OutletController> {

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
                    print(outlet);
                    return OutletCard(outlet: outlet);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutletCard extends StatelessWidget {
  final Outlet outlet;

  const OutletCard({
    Key? key,
    required this.outlet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            Color(0xFFFFFFFF),
            Color(0x80FFFFFF),
          ])),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nama Outlet :',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    outlet.outletName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kategori Outlet',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    outlet.category,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(
                          () =>  TambahOutlet()
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(80, 36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                    ),
                    child: const Text(
                      'Lihat',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/carousel1.png",
                    width: 100,
                    height: 100,

                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
