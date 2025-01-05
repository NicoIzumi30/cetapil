import 'dart:convert';
import 'dart:io';

import 'package:cetapil_mobile/controller/activity/detail_activity_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:cetapil_mobile/model/list_activity_response.dart' as Activity;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../secondarytab_page/tambah_kompetitor_visibility.dart';
import '../secondarytab_page/tambah_primary_visibility.dart';
import '../secondarytab_page/tambah_secondary_visibility.dart';
import '../secondarytab_page/visibility.dart';
import 'detail_item_visibility/detail_visibility_primary.dart';
import 'detail_item_visibility/detail_visibility_secondary.dart';

const String BASE_URL = 'https://dev-cetaphil.i-am.host/storage';

class DetailVisibilityPage extends GetView<DetailActivityController> {
  final supportController = Get.find<SupportDataController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Primary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        CollapsibleVisibilityGroup(
          title: 'Core',
          items: [
            Obx(() {
              var id = "primary-core-1";
              var data = controller.visibilityPrimaryDetailItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: true,
                posmType: data['posm_type_name'] ?? "-",
                visualType: data['visual_type_name'] ?? "-",
                condition: data['condition'] ?? "-",
                imagePath: data['image_visibility'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  Get.to(() => DetailVisibilityPrimary(
                    data: data
                  ));
                },
              );
            }),
            Obx(() {
              var id = "primary-core-2";
              var data = controller.visibilityPrimaryDetailItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: true,
                posmType: data['posm_type_name'] ?? "-",
                visualType: data['visual_type_name'] ?? "-",
                condition: data['condition'] ?? "-",
                imagePath: data['image_visibility'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  Get.to(() => DetailVisibilityPrimary(
                      data: data
                  ));
                },
              );
            }),
            Obx(() {
              var id = "primary-core-3";
              var data = controller.visibilityPrimaryDetailItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: true,
                posmType: data['posm_type_name'] ?? "-",
                visualType: data['visual_type_name'] ?? "-",
                condition: data['condition'] ?? "-",
                imagePath: data['image_visibility'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  Get.to(() => DetailVisibilityPrimary(
                      data: data
                  ));
                },
              );
            }),
          ],
        ),
        SizedBox(height: 8),
        CollapsibleVisibilityGroup(
          title: 'Baby',
          items: [
            Obx(() {
              var id = "primary-baby-1";
              var data = controller.visibilityPrimaryDetailItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: true,
                posmType: data['posm_type_name'] ?? "-",
                visualType: data['visual_type_name'] ?? "-",
                condition: data['condition'] ?? "-",
                imagePath: data['image_visibility'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  Get.to(() => DetailVisibilityPrimary(
                      data: data
                  ));
                },
              );
            }),
            Obx(() {
              var id = "primary-baby-2";
              var data = controller.visibilityPrimaryDetailItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: true,
                posmType: data['posm_type_name'] ?? "-",
                visualType: data['visual_type_name'] ?? "-",
                condition: data['condition'] ?? "-",
                imagePath: data['image_visibility'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  Get.to(() => DetailVisibilityPrimary(
                    data: data,
                  ));
                },
              );
            }),
            Obx(() {
              var id = "primary-baby-3";
              var data = controller.visibilityPrimaryDetailItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: true,
                posmType: data['posm_type_name'] ?? "-",
                visualType: data['visual_type_name'] ?? "-",
                condition: data['condition'] ?? "-",
                imagePath: data['image_visibility'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  Get.to(() => DetailVisibilityPrimary(
                    data: data,
                  ));
                },
              );
            }),
          ],
        ),
        SizedBox(height: 16),

        // === Secondary Visibility ===
        Text(
          'Secondary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        CollapsibleVisibilityGroup(
          title: 'Core',
          items: [
            Obx(() {
              var id = "secondary-core-1";
              var data = controller.visibilitySecondaryDetailItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: false,
                secondarydisplay: data['secondary_exist'] ?? "-",
                typeDisplay: data['display_type'] ?? "-",
                imagePath: data['display_image'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  Get.to(() => DetailVisibilitySecondary(
                    data: data,
                  ));
                },
              );
            }),
            Obx(() {
              var id = "secondary-core-2";
              var data = controller.visibilitySecondaryDetailItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: false,
                secondarydisplay: data['secondary_exist'] ?? "-",
                typeDisplay: data['display_type'] ?? "-",
                imagePath: data['display_image'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  Get.to(() => DetailVisibilitySecondary(
                    data: data,
                  ));
                },
              );
            }),
          ],
        ),
        SizedBox(height: 8),
        CollapsibleVisibilityGroup(
          title: 'Baby',
          items: [
            Obx(() {
              var id = "secondary-baby-1";
              var data = controller.visibilitySecondaryDetailItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: false,
                secondarydisplay: data['secondary_exist'] ?? "-",
                typeDisplay: data['display_type'] ?? "-",
                imagePath: data['display_image'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  Get.to(() => DetailVisibilitySecondary(
                    data: data,
                  ));
                },
              );
            }),
            Obx(() {
              var id = "secondary-baby-2";
              var data = controller.visibilitySecondaryDetailItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: false,
                secondarydisplay: data['secondary_exist'] ?? "-",
                typeDisplay: data['display_type'] ?? "-",
                imagePath: data['display_image'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  Get.to(() => DetailVisibilitySecondary(
                    data: data,
                  ));
                },
              );
            }),
          ],
        ),
        SizedBox(height: 16),

        // === Kompetitor Visibility ===
        Text(
          'Kompetitor',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Obx(() {
          var id = "kompetitor-kompetitor-1";
          var data = controller.visibilityKompetitorDetailItems
              .firstWhere((item) => item['id'] == id, orElse: () => {});
          return KompetitorCard(
            brandName: data['brand_name'] ?? "-",
            promoMechanism: data['promo_mechanism'] ?? "-",
            promoPeriode: data['promo_periode_start'] != null ? "${data['promo_periode_start']} - ${data['promo_periode_end']}" : "-",
            imagePath: data['program_image1'],
            isSubmitted: data.isNotEmpty,
            onTapCard: () {
              Get.to(() => DetailVisibilitySecondary(
                data: data,
              ));
            },
          );
        }),
        Obx(() {
          var id = "kompetitor-kompetitor-2";
          var data = controller.visibilityKompetitorDetailItems
              .firstWhere((item) => item['id'] == id, orElse: () => {});
          return KompetitorCard(
            brandName: data['brand_name'] ?? "-",
            promoMechanism: data['promo_mechanism'] ?? "-",
            promoPeriode: data['promo_periode_start'] != null ? "${data['promo_periode_start']} - ${data['promo_periode_end']}" : "-",
            imagePath: data['program_image1'],
            isSubmitted: data.isNotEmpty,
            onTapCard: () {
              Get.to(() => DetailVisibilitySecondary(
                data: data,
              ));
            },
          );
        }),
        SizedBox(height: 16),
      ],
    );
  }
}

class VisibilityCard extends StatelessWidget {
  final bool isPrimary;

  ///primary
  final String? posmType;
  final String? visualType;
  final String? condition;

  ///secondary
  final String? secondarydisplay;
  final String? typeDisplay;

  final File? imagePath;
  final bool isSubmitted;
  final VoidCallback? onTapCard; // Added this parameter

  const VisibilityCard({
    Key? key,
    this.posmType,
    this.visualType,
    this.condition,
    this.secondarydisplay,
    this.typeDisplay,
    this.imagePath,
    this.isSubmitted = false,
    this.onTapCard,
    required this.isPrimary, // Optional callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCardWithImage();
  }

  Widget _buildCardWithImage() {
    return InkWell(
      onTap: onTapCard,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: isPrimary
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Jenis Display:', posmType!),
                          SizedBox(height: 8),
                          _buildInfoRow('Jenis Visual:', visualType!),
                          SizedBox(height: 8),
                          _buildInfoRow('Condition', condition!),
                        ],
                      )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Display Secondary:', secondarydisplay!),
                          SizedBox(height: 8),
                          _buildInfoRow('Display Type:', typeDisplay!),
                        ],
                      )),
                  SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imagePath != null
                        ? SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.file(
                          imagePath!,
                          fit: BoxFit.cover,
                        ))
                        : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: Icon(Icons.image_outlined, color: Colors.grey[400]),
                    ),
                  ),
                ],
              ),
            ),
            if (isSubmitted)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
