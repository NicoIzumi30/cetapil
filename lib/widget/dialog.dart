import 'package:cetapil_mobile/controller/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';

class Alerts {
  static showConfirmDialog(
    BuildContext context, {
    bool useGetBack = true,
    Function? onContinue,
  }) async {
    return showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'KONFIRMASI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Apakah anda yakin?',
                style: TextStyle(fontSize: 13),
              ),
              Text(
                'Progress anda akan hilang ketika keluar',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate adaptive padding based on available width
                  final horizontalPadding = (constraints.maxWidth < 300) 
                      ? 15.0  // Smaller padding for very narrow screens
                      : (constraints.maxWidth < 400) 
                          ? 20.0  // Medium padding for narrow screens
                          : 30.0;  // Default padding for wider screens

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: constraints.maxWidth * 0.4, // Limit button width
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              useGetBack ? Get.back() : Navigator.pop(dialogContext);
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Batalkan',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8), // Add spacing between buttons
                      Flexible(
                        child: SizedBox(
                          width: constraints.maxWidth * 0.4, // Limit button width
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: AppColors.primary, width: 1),
                              ),
                            ),
                            onPressed: () {
                              onContinue?.call();
                              if (useGetBack) {
                                Get.back();
                                Get.back();
                              } else {
                                Navigator.pop(dialogContext);
                                Navigator.pop(context);
                              }
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Lanjutkan',
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static showLogOutDialog(BuildContext context, {bool useGetBack = true}) async {
    DashboardController controller = Get.find<DashboardController>();
    return showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'KONFIRMASI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Apakah anda yakin ingin keluar',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 34),
              LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = (constraints.maxWidth < 300) 
                      ? 15.0 
                      : (constraints.maxWidth < 400) 
                          ? 20.0 
                          : 30.0;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: constraints.maxWidth * 0.4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              useGetBack ? Get.back() : Navigator.pop(dialogContext);
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Batalkan',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: SizedBox(
                          width: constraints.maxWidth * 0.4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: AppColors.primary, width: 1),
                              ),
                            ),
                            onPressed: () => controller.logOut(),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Lanjutkan',
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}