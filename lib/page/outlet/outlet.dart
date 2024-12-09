import 'dart:io';

import 'package:cetapil_mobile/controller/outlet/outlet_controller.dart';
import 'package:cetapil_mobile/model/outlet.dart';
import 'package:cetapil_mobile/page/activity/activity.dart';
import 'package:cetapil_mobile/page/activity/tambah_activity.dart';
import 'package:cetapil_mobile/page/outlet/detail_outlet.dart';
import 'package:cetapil_mobile/page/outlet/tambah_outlet.dart';
import 'package:cetapil_mobile/widget/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OutletPage extends GetView<OutletController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Column(
            children: [
              // Search Bar
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
              SizedBox(height: 10),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ButtonPrimary(
                        ontap: () {
                          controller.setListOutletPage(1);
                        },
                        title: "Outlet",
                        tipeButton: controller.listOutletPage == 1 ? "primary" : "info",
                        // width: MediaQuery.of(context).size.width * 0.45,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ButtonPrimary(
                        ontap: () {
                          controller.setListOutletPage(2);
                        },
                        title: "Approval",
                        tipeButton: controller.listOutletPage == 2 ? "primary" : "info",
                        // width: MediaQuery.of(context).size.width * 0.45,
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: 10),

              // Main Content
              Expanded(
                child: Obx(() {
                  if (controller.listOutletPage == 1) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        // Use refreshOutlets instead of syncOutlets
                        await controller.refreshOutlets();
                      },
                      child: Stack(
                        children: [
                          // Main Content
                          controller.filteredOutlets.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: controller.filteredOutlets.length,
                                  itemBuilder: (context, index) {
                                    final outlet = controller.filteredOutlets[index];
                                    return OutletCard(outlet: outlet);
                                  },
                                ),

                          // Loading Overlay
                          if (controller.isSyncing.value)
                            Container(
                              color: Colors.black12,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text(
                                      'Menyinkronkan data...',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        // Use refreshOutlets instead of syncOutlets
                        await controller.refreshOutlets();
                      },
                      child: Stack(
                        children: [
                          // Main Content
                          controller.filteredOutletsApproval.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: controller.filteredOutletsApproval.length,
                                  itemBuilder: (context, index) {
                                    final outlet = controller.filteredOutletsApproval[index];
                                    return OutletCard(outlet: outlet);
                                  },
                                ),

                          // Loading Overlay
                          if (controller.isSyncing.value)
                            Container(
                              color: Colors.black12,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text(
                                      'Menyinkronkan data...',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clearForm(); // Clear the form first
          Get.to(() => TambahOutlet());
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
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
              SvgPicture.asset("assets/icon/Vector2.svg",height: 64,
                color: Colors.grey,),
              SizedBox(height: 16),
              Text(
                'Tidak ada outlet',
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

class OutletCard extends StatelessWidget {
  final OutletController outletController = Get.find<OutletController>();
  final Outlet outlet;

  OutletCard({
    Key? key,
    required this.outlet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFFFFF),
            Color(0x80FFFFFF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Outlet Name
                  Text(
                    'Nama Outlet :',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    outlet.name ?? 'Unnamed Outlet',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Category
                  Text(
                    'Kategori Outlet',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    outlet.category ?? 'Uncategorized',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // City
                  Text(
                    'Kota :',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    outlet.city?.name ?? 'Not Specified',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Address
                  Text(
                    'Alamat :',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    outlet.address ?? 'No Address',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Draft Status
                  if (outlet.dataSource == 'DRAFT')
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 12,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Draft',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Action Button
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          outlet.dataSource != "DRAFT"
                              ? Get.to(() => DetailOutlet(outlet: outlet,isCheckin: false,))
                              : outletController.setDraftValue(outlet);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(80, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Lihat',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      if (outlet.dataSource == 'DRAFT') ...[
                        SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {
                            // Add delete confirmation dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Hapus Draft'),
                                content: Text('Apakah Anda yakin ingin menghapus draft ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await outletController.db.deleteOutlet(outlet.id!);
                                      await outletController.loadOutlets();
                                    },
                                    child: Text('Hapus'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            minimumSize: const Size(80, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Hapus'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: outlet.images != null && outlet.images!.isNotEmpty
                      ? Image.file(
                          File(outlet.images!.first.image ?? ''),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/carousel1.png",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
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
