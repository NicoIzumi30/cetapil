import 'package:cetapil_mobile/controller/outlet/outlet_controller.dart';
import 'package:cetapil_mobile/model/outlet.dart';
import 'package:cetapil_mobile/page/outlet/detail_outlet.dart';
import 'package:cetapil_mobile/page/outlet/tambah_outlet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OutletPage extends GetView<OutletController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make scaffold background transparent
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
              SizedBox(height: 15),
              Expanded(
                child: Obx(
                  () => RefreshIndicator(
                    onRefresh: () async {
                      await controller.syncOutlets();
                    },
                    child: controller.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : controller.filteredOutlets.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: controller.filteredOutlets.length,
                                itemBuilder: (context, index) {
                                  final outlet = controller.filteredOutlets[index];
                                  return OutletCard(outlet: outlet);
                                },
                              ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => TambahOutlet()),
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
                  outlet.dataSource != 'DRAFT'
                      ? Container()
                      : Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 12,
                              color: outlet.dataSource == 'DRAFT' ? Colors.orange : Colors.green,
                            ),
                            SizedBox(width: 4),
                            Text(
                              outlet.dataSource == 'DRAFT' ? 'Draft' : 'Synced',
                              style: TextStyle(
                                fontSize: 12,
                                color: outlet.dataSource == 'DRAFT' ? Colors.orange : Colors.green,
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.to(() => DetailOutlet(outlet: outlet)),
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
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: outlet.images != null && outlet.images!.isNotEmpty
                      ? Image.network(
                          outlet.images!.first.image ?? '',
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
