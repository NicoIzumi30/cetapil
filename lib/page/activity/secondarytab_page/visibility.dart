import 'dart:convert';
import 'dart:io';

import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_visibility_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/tambah_kompetitor_visibility.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/tambah_primary_visibility.dart';
import 'package:cetapil_mobile/controller/activity/activity_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:cetapil_mobile/model/list_activity_response.dart' as Activity;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/tambah_secondary_visibility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';

const String BASE_URL = 'https://dev.cetaphil.id/storage/';

class VisibilityPage extends GetView<ActivityController> {
  final supportController = Get.find<SupportDataController>();
  final tambahActivityController = Get.find<TambahActivityController>();

  // final tambahVisibilityController = Get.find<TambahVisibilityController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === Primary Visibility ===
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
              var data = tambahActivityController.visibilityPrimaryDraftItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: true,
                posmType: data['posm_type_name'] ?? "-",
                visualType: data['visual_type_name'] ?? "-",
                condition: data['condition'] ?? "-",
                imagePath: data['image_visibility'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  // Your custom tap handling here
                  if (!Get.isRegistered<TambahVisibilityController>()) {
                    Get.put(TambahVisibilityController());
                  }
                  Get.find<TambahVisibilityController>().initPrimaryVisibilityItem(id);

                  Get.to(() => TambahPrimaryVisibility(
                        id: id,
                      ));
                },
              );
            }),
            Obx(() {
              var id = "primary-core-2";
              var data = tambahActivityController.visibilityPrimaryDraftItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: true,
                posmType: data['posm_type_name'] ?? "-",
                visualType: data['visual_type_name'] ?? "-",
                condition: data['condition'] ?? "-",
                imagePath: data['image_visibility'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  var id = "primary-core-2";
                  // Your custom tap handling here
                  if (!Get.isRegistered<TambahVisibilityController>()) {
                    Get.put(TambahVisibilityController());
                  }
                  Get.find<TambahVisibilityController>().initPrimaryVisibilityItem(id);

                  Get.to(() => TambahPrimaryVisibility(
                        id: id,
                      ));
                },
              );
            }),
            Obx(() {
              var id = "primary-core-3";
              var data = tambahActivityController.visibilityPrimaryDraftItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              print("primary = ${tambahActivityController.visibilityPrimaryDraftItems}");
              return VisibilityCard(
                isPrimary: true,
                posmType: data['posm_type_name'] ?? "-",
                visualType: data['visual_type_name'] ?? "-",
                condition: data['condition'] ?? "-",
                imagePath: data['image_visibility'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  // Your custom tap handling here
                  if (!Get.isRegistered<TambahVisibilityController>()) {
                    Get.put(TambahVisibilityController());
                  }
                  Get.find<TambahVisibilityController>().initPrimaryVisibilityItem(id);

                  Get.to(() => TambahPrimaryVisibility(
                        id: id,
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
              var data = tambahActivityController.visibilityPrimaryDraftItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: true,
                posmType: data['posm_type_name'] ?? "-",
                visualType: data['visual_type_name'] ?? "-",
                condition: data['condition'] ?? "-",
                imagePath: data['image_visibility'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  // Your custom tap handling here
                  if (!Get.isRegistered<TambahVisibilityController>()) {
                    Get.put(TambahVisibilityController());
                  }
                  Get.find<TambahVisibilityController>().initPrimaryVisibilityItem(id);

                  Get.to(() => TambahPrimaryVisibility(
                        id: id,
                      ));
                },
              );
            }),
            Obx(() {
              var id = "primary-baby-2";
              var data = tambahActivityController.visibilityPrimaryDraftItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: true,
                posmType: data['posm_type_name'] ?? "-",
                visualType: data['visual_type_name'] ?? "-",
                condition: data['condition'] ?? "-",
                imagePath: data['image_visibility'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  var id = "primary-baby-2";
                  // Your custom tap handling here
                  if (!Get.isRegistered<TambahVisibilityController>()) {
                    Get.put(TambahVisibilityController());
                  }
                  Get.find<TambahVisibilityController>().initPrimaryVisibilityItem(id);

                  Get.to(() => TambahPrimaryVisibility(
                        id: id,
                      ));
                },
              );
            }),
            Obx(() {
              var id = "primary-baby-3";
              var data = tambahActivityController.visibilityPrimaryDraftItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: true,
                posmType: data['posm_type_name'] ?? "-",
                visualType: data['visual_type_name'] ?? "-",
                condition: data['condition'] ?? "-",
                imagePath: data['image_visibility'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  var id = "primary-baby-3";
                  // Your custom tap handling here
                  if (!Get.isRegistered<TambahVisibilityController>()) {
                    Get.put(TambahVisibilityController());
                  }
                  Get.find<TambahVisibilityController>().initPrimaryVisibilityItem(id);

                  Get.to(() => TambahPrimaryVisibility(
                        id: id,
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
              var data = tambahActivityController.visibilitySecondaryDraftItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: false,
                secondarydisplay: data['secondary_exist'] ?? "-",
                typeDisplay: data['display_type'] ?? "-",
                imagePath: data['display_image'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  if (!Get.isRegistered<TambahVisibilityController>()) {
                    Get.put(TambahVisibilityController());
                  }
                  Get.find<TambahVisibilityController>().initSecondaryVisibilityItem(id);
                  Get.to(() => TambahSecondaryVisibility(
                        id: id,
                      ));
                },
              );
            }),
            Obx(() {
              var id = "secondary-core-2";
              var data = tambahActivityController.visibilitySecondaryDraftItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: false,
                secondarydisplay: data['secondary_exist'] ?? "-",
                typeDisplay: data['display_type'] ?? "-",
                imagePath: data['display_image'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  if (!Get.isRegistered<TambahVisibilityController>()) {
                    Get.put(TambahVisibilityController());
                  }
                  Get.find<TambahVisibilityController>().initSecondaryVisibilityItem(id);
                  Get.to(() => TambahSecondaryVisibility(
                        id: id,
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
              var data = tambahActivityController.visibilitySecondaryDraftItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: false,
                secondarydisplay: data['secondary_exist'] ?? "-",
                typeDisplay: data['display_type'] ?? "-",
                imagePath: data['display_image'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  if (!Get.isRegistered<TambahVisibilityController>()) {
                    Get.put(TambahVisibilityController());
                  }
                  Get.find<TambahVisibilityController>().initSecondaryVisibilityItem(id);
                  Get.to(() => TambahSecondaryVisibility(
                        id: id,
                      ));
                },
              );
            }),
            Obx(() {
              var id = "secondary-baby-2";
              var data = tambahActivityController.visibilitySecondaryDraftItems
                  .firstWhere((item) => item['id'] == id, orElse: () => {});
              return VisibilityCard(
                isPrimary: false,
                secondarydisplay: data['secondary_exist'] ?? "-",
                typeDisplay: data['display_type'] ?? "-",
                imagePath: data['display_image'],
                isSubmitted: data.isNotEmpty,
                onTapCard: () {
                  if (!Get.isRegistered<TambahVisibilityController>()) {
                    Get.put(TambahVisibilityController());
                  }
                  Get.find<TambahVisibilityController>().initSecondaryVisibilityItem(id);
                  Get.to(() => TambahSecondaryVisibility(
                        id: id,
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
          var data = tambahActivityController.visibilityKompetitorDraftItems
              .firstWhere((item) => item['id'] == id, orElse: () => {});
          return KompetitorCard(
            brandName: data['brand_name'] ?? "-",
            promoMechanism: data['promo_mechanism'] ?? "-",
            promoPeriode: data['promo_periode_start'] != null ? "${data['promo_periode_start']} - ${data['promo_periode_end']}" : "-",
            imagePath: data['program_image1'],
            isSubmitted: data.isNotEmpty,
            onTapCard: () {
              if (!Get.isRegistered<TambahVisibilityController>()) {
                Get.put(TambahVisibilityController());
              }
              Get.find<TambahVisibilityController>().initKompetitorVisibilityItem(id);
              Get.to(() => TambahKompetitorVisibility(
                    id: id,
                  ));
            },
          );
        }),
        Obx(() {
          var id = "kompetitor-kompetitor-2";
          var data = tambahActivityController.visibilityKompetitorDraftItems
              .firstWhere((item) => item['id'] == id, orElse: () => {});
          return KompetitorCard(
            brandName: data['brand_name'] ?? "-",
            promoMechanism: data['promo_mechanism'] ?? "-",
            promoPeriode: data['promo_periode_start'] != null ? "${data['promo_periode_start']} - ${data['promo_periode_end']}" : "-",
            imagePath: data['program_image1'],
            isSubmitted: data.isNotEmpty,
            onTapCard: () {
              if (!Get.isRegistered<TambahVisibilityController>()) {
                Get.put(TambahVisibilityController());
              }
              Get.find<TambahVisibilityController>().initKompetitorVisibilityItem(id);
              Get.to(() => TambahKompetitorVisibility(
                    id: id,
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

class KompetitorCard extends StatelessWidget {
  final String brandName;
  final String promoMechanism;
  final String promoPeriode;

  final File? imagePath;
  final bool isSubmitted;
  final VoidCallback onTapCard; // Added this parameter

  const KompetitorCard({
    Key? key,
    this.isSubmitted = false,
    required this.brandName,
    required this.promoMechanism,
    required this.promoPeriode,
    this.imagePath,
    required this.onTapCard, // Optional callback
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
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Nama Brand', brandName),
                      SizedBox(height: 8),
                      _buildInfoRow('Mekanisme Promo:', promoMechanism),
                      SizedBox(height: 8),
                      _buildInfoRow('Periode Promo', promoPeriode),
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

class CollapsibleVisibilityGroup extends StatefulWidget {
  final String title;
  final List<Widget> items;

  const CollapsibleVisibilityGroup({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  State<CollapsibleVisibilityGroup> createState() => _CollapsibleVisibilityGroupState();
}

class _CollapsibleVisibilityGroupState extends State<CollapsibleVisibilityGroup> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: isExpanded ? 8 : 0),
          decoration: BoxDecoration(
            color: Color(0xFFEDF8FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                      color: Color(0xFF023B5E),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF023B5E),
                            ),
                          ),
                          Text(
                            '${widget.items.length} items',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isExpanded)
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Column(
              children: widget.items,
            ),
          ),
      ],
    );
  }
}
