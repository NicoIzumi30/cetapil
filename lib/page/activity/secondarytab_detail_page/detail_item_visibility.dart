import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cetapil_mobile/controller/activity/tambah_visibility_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/colors.dart';
import '../../../utils/image_upload.dart';
import '../../../widget/back_button.dart';
import '../../../widget/dialog.dart';
import '../../../widget/dropdown_textfield.dart';
import '../../../widget/text_field.dart';

const String BASE_URL = 'https://dev-cetaphil.i-am.host/storage/';

class DetailItemVisibility extends StatelessWidget {
  const DetailItemVisibility(this.detailItem, {super.key});
  final Map<String, dynamic> detailItem;
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
      onWillPop: ()async{
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
                              _buildReadOnlyField(
                                label: "Jenis Visibility",
                                value: detailItem["posm_type_name"],
                              ),
                              _buildReadOnlyField(
                                label: "Jenis Visual",
                                value: detailItem['visual_type_name'],
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
                                  child: detailItem['planogram'] != null
                                      ? _buildPlanogramImage(detailItem['planogram'])
                                      : Container(
                                    color: Colors.grey[200],
                                    child: Center(
                                      child:
                                      Icon(Icons.image_not_supported, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              ModernTextField(
                                enable: false,
                                title: "Condition",
                                controller:
                                TextEditingController(text: detailItem['condition']),
                              ),
                              _buildImageUploader( "Foto Visibility 1", detailItem['image1'] ?? ""),
                              _buildImageUploader( "Foto Visibility 2", detailItem['image2'] ?? ""),
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

  Widget _buildPlanogramImage(String? image) {
    final imageUrl = _getImageUrl(image);

    if (imageUrl != null) {
      return CachedNetworkImage(
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
      );
    } else if (image!.startsWith('data:image') || image.startsWith('/9j/')) {
      try {
        return Image.memory(
          base64Decode(image.split(',').last),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: Icon(Icons.error),
          ),
        );
      } catch (e) {
        print('Error loading base64 image: $e');
        return Container(
          color: Colors.grey[200],
          child: Icon(Icons.error),
        );
      }
    }

    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F3FF),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF0077BD),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploader(String title,String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 150,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF8FF),
            border: Border.all(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: url.isNotEmpty
              ? Image.network(
            "$BASE_URL$url",
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 40,
                ),
              );
            },
          )
              : const Center(
            child: Icon(
              Icons.image,
              color: Colors.grey,
              size: 40,
            ),
          ),
        )
      ],
    );
  }
}
