import 'package:cetapil_mobile/page/selling/detail_selling.dart';
import 'package:cetapil_mobile/page/selling/tambah_selling.dart';
import 'package:cetapil_mobile/utils/colors.dart';
import 'package:cetapil_mobile/model/outlet.dart' as O;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/selling/selling_controller.dart';
import '../../model/list_selling_response.dart';

class SellingPage extends GetView<SellingController> {
  const SellingPage({Key? key}) : super(key: key);

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
                  hintStyle: MaterialStatePropertyAll(
                    TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Obx(() {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await controller.refreshData();
                    },
                    child: Stack(
                      children: [
                        controller.filteredSellingData.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: controller.filteredSellingData.length,
                                itemBuilder: (context, index) {
                                  final selling = controller.filteredSellingData[index];
                                  if (selling == null) return const SizedBox.shrink();
                                  
                                  return SellingCard(
                                    selling: selling,
                                    controller: controller,
                                    ontap: () {
                                      if (selling.isDrafted ?? false) {
                                        controller.loadDraftForEdit(selling);
                                        Get.to(() => TambahSelling());
                                      } else {
                                        Get.to(() => DetailSelling(selling));
                                      }
                                    },
                                  );
                                },
                              ),
                      ],
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
          controller.clearForm();
          controller.onOpen();
          Get.to(() => TambahSelling());
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 100),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icon/Vector4.svg",
                height: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak ada data penjualan',
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
    );
  }
}

class SellingCard extends StatelessWidget {
  final Data selling;
  final SellingController controller;
  final VoidCallback ontap;

  const SellingCard({
    Key? key,
    required this.selling,
    required this.controller,
    required this.ontap,
  }) : super(key: key);

  O.Outlet get outlet {
    try {
      return controller.filteredOutlets.firstWhere(
        (element) => element.id == selling.outlet?.id,
        orElse: () => O.Outlet(
          id: selling.outlet?.id ?? "",
          name: 'Unknown Outlet',
          category: 'Unknown Category',
        ),
      );
    } catch (e) {
      debugPrint('Error getting outlet: $e');
      return O.Outlet(
        id: "",
        name: 'Error Loading Outlet',
        category: 'Unknown Category',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final outletName = selling.outlet?.name ?? 'No Name';
    final formattedDate = selling.createdAt != null
        ? DateFormat('EEEE, dd/MM/yyyy').format(DateTime.parse(selling.createdAt!))
        : '-';

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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
                        outletName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (outlet.category != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Kategori Outlet: ${outlet.category}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusContainer(),
                Row(
                  children: [
                    if (selling.isDrafted ?? false) _buildDeleteButton(context),
                    const SizedBox(width: 8),
                    _buildViewButton(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusContainer() {
    final isDrafted = selling.isDrafted ?? false;
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: isDrafted ? Colors.white : AppColors.primary,
        borderRadius: BorderRadius.circular(4),
        border: isDrafted ? Border.all(color: AppColors.primary) : null,
      ),
      child: Center(
        child: Text(
          isDrafted ? 'Draft' : 'Terkirim',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDrafted ? AppColors.primary : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showDeleteConfirmation(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[400],
        minimumSize: const Size(80, 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: const Text('Hapus'),
    );
  }

  Widget _buildViewButton() {
    return ElevatedButton(
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
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Draft'),
        content: const Text('Apakah Anda yakin ingin menghapus draft ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (selling.id != null) {
                Get.find<SellingController>().deleteDraft(selling.id!);
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}