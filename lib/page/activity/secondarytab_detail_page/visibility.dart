import 'dart:convert';
import 'dart:io';

import 'package:cetapil_mobile/controller/activity/detail_activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_visibility_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/tambah_visibility.dart';
import 'package:cetapil_mobile/controller/activity/activity_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:cetapil_mobile/model/list_activity_response.dart' as Activity;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'detail_item_visibility.dart';

const String BASE_URL = 'https://dev-cetaphil.i-am.host/storage';

class DetailVisibilityPage extends GetView<DetailActivityController> {
  final supportController = Get.find<SupportDataController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          // final allVisibilities = detailActivityController.detailOutlet.value!.visibilities ?? [];
          final allVisibilities = controller.visibilityItems;

          if (allVisibilities.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No visibility data available',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: allVisibilities.length,
            itemBuilder: (context, index) {
              final visibility = allVisibilities[index];
              final posmType = supportController
                  .getPosmTypes()
                  .firstWhereOrNull((posm) => posm['id'] == visibility['posm_type_id']);
              final visualType = supportController
                  .getVisualTypes()
                  .firstWhereOrNull((visual) => visual['id'] == visibility['visual_type_id']);
              return VisibilityCard(
                visibility: visibility,
                posmTypeName: posmType?['name'] ?? 'Unknown POSM Type',
                visualTypeName: visualType?['name'] ?? 'Unknown Visual Type',
                onTapCard: () {
                  final itemData = {
                    'posm_type_name': posmType!['name'],
                    'visual_type_name': visualType!['name'],
                    'condition': visibility['condition'],
                    'planogram': visibility['planogram'],
                    'image1': visibility['image1'],
                    'image2': visibility['image2'],
                  };

                  Get.to(() => DetailItemVisibility(itemData));
                },
              );
            },
          );
        }),
      ],
    );
  }
}

class VisibilityCard extends StatelessWidget {
  final Map<String, dynamic> visibility;
  final String posmTypeName;
  final String visualTypeName;
  final VoidCallback onTapCard;

  const VisibilityCard({
    Key? key,
    required this.visibility,
    required this.posmTypeName,
    required this.visualTypeName,
    required this.onTapCard,
  }) : super(key: key);

  String? _getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    if (imagePath.startsWith('data:image') || imagePath.startsWith('/9j/')) {
      return null;
    }
    String path = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$BASE_URL/$path';
  }

  Widget _buildImage() {
    final detailActivityController = Get.find<DetailActivityController>();

    // Check for draft image first
    final draftItem = detailActivityController.visibilityItems
        .firstWhereOrNull((draft) => draft['id'] == visibility['id']);

    print("$BASE_URL${draftItem!['image1']}");
    if (draftItem != null && draftItem['image1'] != null) {
      // Show draft image1 if available
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          "$BASE_URL${draftItem!['image1']}",
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 120,
            height: 120,
            color: Colors.grey[200],
            child: Icon(Icons.error),
          ),
        ),
      );
    }

    // Fall back to original image logic
    if (visibility['planogram'] == null) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    final imageUrl = _getImageUrl(visibility['planogram']);

    print(imageUrl != null);
    if (imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 120,
          height: 120,
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
      );
    } else if (visibility['planogram'].startsWith('data:image') || visibility['planogram'].startsWith('/9j/')) {
      try {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(
            base64Decode(visibility['planogram']!.split(',').last),
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 120,
              height: 120,
              color: Colors.grey[200],
              child: Icon(Icons.error),
            ),
          ),
        );
      } catch (e) {
        print('Error loading base64 image: $e');
        return Container(
          width: 120,
          height: 120,
          color: Colors.grey[200],
          child: Icon(Icons.error),
        );
      }
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailActivityController = Get.find<DetailActivityController>();

    return Obx(() {
      // Check if this visibility exists in draft items
      final hasDraft =
      detailActivityController.visibilityItems.any((draft) => draft['id'] == visibility['id']);

      return InkWell(
        onTap: onTapCard,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFFF),
                Color(0x80FFFFFF),
              ],
            ),
            border: Border.all(
              color: hasDraft ? Colors.blue : Colors.grey.withOpacity(0.2),
              width: hasDraft ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("POSM Type", posmTypeName),
                        SizedBox(height: 8),
                        _buildInfoRow("Visual Type", visualTypeName),
                      ],
                    ),
                  ),
                  _buildImage(),
                ],
              ),
              if (hasDraft)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
