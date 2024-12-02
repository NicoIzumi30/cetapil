import 'dart:convert';

import 'package:cetapil_mobile/controller/activity/tambah_visibility_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/tambah_visibility.dart';
import 'package:cetapil_mobile/controller/activity/activity_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:cetapil_mobile/model/list_activity_response.dart' as Activity;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String BASE_URL = 'https://dev-cetaphil.i-am.host/storage/';

class VisibilityPage extends GetView<ActivityController> {
  final supportController = Get.find<SupportDataController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final allVisibilities =
              controller.activity.expand((activity) => activity.visibilities ?? []).toList();

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
                  .firstWhereOrNull((posm) => posm['id'] == visibility.posmTypeId);
              final visualType = supportController
                  .getVisualTypes()
                  .firstWhereOrNull((visual) => visual['id'] == visibility.visualTypeId);

              return VisibilityCard(
                visibility: visibility,
                posmTypeName: posmType?['name'] ?? 'Unknown POSM Type',
                visualTypeName: visualType?['name'] ?? 'Unknown Visual Type',
                onTapCard: () {
                  if (!Get.isRegistered<TambahVisibilityController>()) {
                    // Create and initialize a new controller
                    Get.put(TambahVisibilityController());
                  }

// Get the existing controller instance
                  final controller = Get.find<TambahVisibilityController>();

                  controller.updateWithArgs(
                    posmType: posmType,
                    visualType: visualType,
                    isReadOnly: true,
                    visibility: visibility,
                  );

                  // Navigate to the page
                  Get.to(
                    () => TambahVisibility(),
                    arguments: controller,
                  );
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
  final Activity.Visibilities visibility;
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
    return '$BASE_URL$path';
  }

  Widget _buildImage() {
    if (visibility.image == null) {
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

    final imageUrl = _getImageUrl(visibility.image);

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
    } else if (visibility.image!.startsWith('data:image') || visibility.image!.startsWith('/9j/')) {
      try {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(
            base64Decode(visibility.image!.split(',').last),
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
            color: Colors.grey.withOpacity(0.2),
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
        child: Row(
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
      ),
    );
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
