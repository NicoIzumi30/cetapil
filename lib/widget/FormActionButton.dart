import 'package:cetapil_mobile/utils/colors.dart';
import 'package:cetapil_mobile/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormActionButtons extends StatelessWidget {
  final Future<bool> Function() onSubmit;
  final Future<bool> Function() onSaveDraft;
  
  const FormActionButtons({
    Key? key,
    required this.onSubmit,
    required this.onSaveDraft,
  }) : super(key: key);

  Widget _buildButton(bool isPrimary, String text, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: isPrimary 
                ? BorderSide.none 
                : BorderSide(color: AppColors.primary, width: 1),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }

  Future<void> _handleDraftSave(BuildContext context) async {
    final result = await Alerts.showSaveDraftConfirmDialog(
      context,
      useGetBack: true,
    );
    
    if (result == true) {
      final success = await onSaveDraft();
      if (success) {
        Get.back();
      }
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final result = await Alerts.showSubmitConfirmDialog(
      context,
      useGetBack: true,
    );
    
    if (result == true) {
      final success = await onSubmit();
      if (success) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            _buildButton(
              false,
              "Simpan Draft",
              () => _handleDraftSave(context),
            ),
            const SizedBox(width: 10),
            _buildButton(
              true,
              "Kirim",
              () => _handleSubmit(context),
            ),
          ],
        ),
      ),
    );
  }
}