import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cetapil_mobile/controller/activity/tambah_visibility_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:cetapil_mobile/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../utils/image_upload.dart';
import '../../../../widget/back_button.dart';
import '../../../../widget/custom_switch.dart';
import '../../../../widget/dialog.dart';
import '../../secondarytab_page/tambah_primary_visibility.dart';

const String BASE_URL = 'https://dev-cetaphil.i-am.host/storage/';

class DetailVisibilityKompetitor extends GetView<TambahVisibilityController> {
  final Map<String, dynamic> data;

  DetailVisibilityKompetitor({
    super.key,
    required this.data
  });

  final supportController = Get.find<SupportDataController>();

  String? _getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;

    if (imagePath.startsWith('data:image') || imagePath.startsWith('/9j/')) {
      return null;
    }

    String path = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$BASE_URL$path';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await Alerts.showConfirmDialog(context);
        return shouldPop ?? false;
      },
      child: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EnhancedBackButton(
                          onPressed: () => Alerts.showConfirmDialog(context, useGetBack: false),
                          backgroundColor: Colors.white,
                          iconColor: Colors.blue,
                          useGetBack: false,
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView(
                            children: [
                              ModernTextField(
                                enable: false,
                                title: "Nama Brand",
                                controller: TextEditingController(text: data['brand_name']),
                              ),
                              ModernTextField(
                                enable: false,
                                title: "Mekanisme Promo",
                                controller: TextEditingController(text: data['promo_mechanism']),
                              ),
                              ModernTextField(
                                enable: false,
                                title: "Promo Periode",
                                controller: TextEditingController(text: "${data['promo_periode_start']} - ${data['promo_periode_end']}"),
                              ),
                              ClipImage(label: "Foto Program Kompetitor 1",url: data['program_image1']),
                              ClipImage(label: "Foto Program Kompetitor 2",url: data['program_image2']),
                            ],
                          ),
                        )
                      ],
                    ),
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

class ClipImage extends StatelessWidget {
  final String? url;
  final double? size;
  final BoxFit fit;
  final String label;

  const ClipImage({
    super.key,
    required this.url,
    this.size,
    this.fit = BoxFit.cover, required this.label,
  });

  String _sanitizeUrl(String url) {
    return "https://dev-cetaphil.i-am.host/storage${url}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: url != null
              ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageViewerScreen(
                  image: _sanitizeUrl(url!),
                ),
              ),
            );
          }
              : null,
          child: SizedBox(
            height: 150,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.blue,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: url != null
                    ? Image.network(
                  _sanitizeUrl(url!),
                  fit: fit,
                  errorBuilder: _buildErrorWidget,
                )
                    : _buildErrorWidget(context, null, null),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(
      BuildContext context, Object? error, StackTrace? stackTrace) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, color: Colors.grey[400], size: 24),
          SizedBox(height: 8),
          Text(
            'No Image',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
