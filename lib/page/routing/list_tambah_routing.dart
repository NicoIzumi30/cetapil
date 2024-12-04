import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/outlet/outlet_controller.dart';
import '../../controller/routing/tambah_routing_controller.dart';
import '../../model/outlet.dart';
import '../../widget/back_button.dart';
import '../outlet/detail_outlet.dart';

class ListTambahRouting extends StatelessWidget {
  final TambahRoutingController controller = Get.find<TambahRoutingController>();
  final OutletController outletController = Get.find<OutletController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EnhancedBackButton(
                  onPressed: () => Get.back(),
                  backgroundColor: Colors.white,
                  iconColor: Colors.blue,
                ),
                SizedBox(height: 10,),
                SizedBox(
                  height: 40,
                  child: SearchBar(
                    controller: TextEditingController(),
                    onChanged: outletController.updateSearchQuery,
                    leading: const Icon(Icons.search),
                    hintText: 'Masukkan Kata Kunci',
                    hintStyle:
                    WidgetStatePropertyAll(TextStyle(color: Colors.grey[500], fontSize: 14)),
                    shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                SizedBox(height: 15),

                // Main Content
                Expanded(
                  child: Obx(
                        () => RefreshIndicator(
                      onRefresh: () async {
                        // Use refreshOutlets instead of syncOutlets
                        await outletController.refreshOutlets();
                      },
                      child: Stack(
                        children: [
                          // Main Content
                          outletController.filteredOutletsApproval.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: outletController.filteredOutletsApproval.length,
                            itemBuilder: (context, index) {
                              final outlet = outletController.filteredOutletsApproval[index];
                              return OutletCard(outlet: outlet);
                            },
                          ),

                          // Loading Overlay
                          if (outletController.isSyncing.value)
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
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
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
              Icon(
                Icons.store_outlined,
                size: 64,
                color: Colors.grey,
              ),
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
                          Get.to(() => DetailOutlet(outlet: outlet,isCheckin: true,));
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