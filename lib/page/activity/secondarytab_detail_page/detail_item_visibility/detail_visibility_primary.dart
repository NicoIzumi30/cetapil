import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cetapil_mobile/controller/activity/detail_activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_visibility_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_detail_page/detail_item_visibility/detail_visibility_secondary.dart';
import 'package:cetapil_mobile/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../utils/image_upload.dart';
import '../../../../widget/back_button.dart';
import '../../../../widget/dialog.dart';
import '../../secondarytab_page/tambah_primary_visibility.dart';

const String BASE_URL = 'https://dev.cetaphil.id/storage/';

class DetailVisibilityPrimary extends GetView<DetailActivityController> {
  final Map<String, dynamic> data;

  DetailVisibilityPrimary({
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
                                title: "Jenis Display",
                                controller: TextEditingController(text: data['posm_type_name']),
                              ),
                              ModernTextField(
                                enable: false,
                                title: "Jenis Visual",
                                controller: TextEditingController(text: data['visual_type_name']),
                              ),

                              Text(
                                "Planogram",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: FutureBuilder<List<Map<String, dynamic>>>(
                                    future: supportController.getPlanogramsByChannel(controller.detailOutlet.value?.channel!.id ??
                                        ''),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Center(child: CircularProgressIndicator()),
                                        );
                                      }

                                      if (snapshot.hasError ||
                                          !snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: Text(
                                              "No planogram available for this channel",
                                              style: TextStyle(color: Colors.grey[600]),
                                            ),
                                          ),
                                        );
                                      }

                                      final planogram = snapshot.data!.first;
                                      final planogramPath = planogram['path'];

                                      if (planogramPath != null && planogramPath.isNotEmpty) {
                                        final imageUrl = '$BASE_URL$planogramPath';
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    FullScreenImageViewer(imageUrl: imageUrl),
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag: 'planogram_image',
                                            child: CachedNetworkImage(
                                              imageUrl: imageUrl,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Container(
                                                color: Colors.grey[200],
                                                child: Center(child: CircularProgressIndicator()),
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                color: Colors.grey[200],
                                                child: Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: Text(
                                              "Invalid planogram image",
                                              style: TextStyle(color: Colors.grey[600]),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              ModernTextField(
                                enable: false,
                                title: "Condition",
                                controller: TextEditingController(text: data['condition']),
                              ),
                              ModernTextField(
                                enable: false,
                                title: "Lebar Rak (cm)",
                                controller: TextEditingController(text: data['shelf_width'].toString()),
                              ),
                              ModernTextField(
                                enable: false,
                                title: "Shelving",
                                controller: TextEditingController(text: data['shelving'].toString()),
                              ),
                              ClipImage(label: "Foto Visibility",url: data['image_visibility'] ),
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
