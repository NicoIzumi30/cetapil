import 'package:cetapil_mobile/controller/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';

class Alerts {
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    bool useGetBack = true,
    Function? onContinue,
  }) async {
    return showDialog<bool>(
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
                              if (useGetBack) {
                                Get.back(result: false);
                              } else {
                                Navigator.pop(dialogContext, false);
                              }
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
                            onPressed: () {
                              onContinue?.call();
                              if (useGetBack) {
                                Get.back(result: true);
                                Get.back();
                              } else {
                                Navigator.pop(dialogContext, true);
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

  static Future<bool?> showSaveDraftConfirmDialog(
    BuildContext context, {
    bool useGetBack = true,
    Function? onContinue,
  }) async {
    return showDialog<bool>(
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
                'SIMPAN DRAFT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Apakah anda yakin ingin menyimpan draft?',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              Text(
                'Data akan tersimpan dan dapat dilanjutkan nanti',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
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
                              if (useGetBack) {
                                Get.back(result: false);
                              } else {
                                Navigator.pop(dialogContext, false);
                              }
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
                            onPressed: () {
                              onContinue?.call();
                              if (useGetBack) {
                                Get.back(result: true);
                              } else {
                                Navigator.pop(dialogContext, true);
                              }
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Simpan',
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

  static Future<bool?> showSubmitConfirmDialog(
    BuildContext context, {
    bool useGetBack = true,
    Function? onContinue,
  }) async {
    return showDialog<bool>(
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
                'KIRIM DATA',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Apakah data yang diisi sudah benar?',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              Text(
                'Data yang sudah dikirim tidak dapat diubah kembali',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
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
                              if (useGetBack) {
                                Get.back(result: false);
                              } else {
                                Navigator.pop(dialogContext, false);
                              }
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Periksa Kembali',
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
                            onPressed: () {
                              onContinue?.call();
                              if (useGetBack) {
                                Get.back(result: true);
                              } else {
                                Navigator.pop(dialogContext, true);
                              }
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Kirim',
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

  static Future<bool?> showSubmitCheckInDialog(
    BuildContext context, {
    bool useGetBack = true,
    Function? onContinue,
  }) async {
    return showDialog<bool>(
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
                'CHECK IN',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Apakah anda ingin Check-in?',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              Text(
                'Data yang sudah di Check-in tidak dapat diubah kembali',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
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
                              if (useGetBack) {
                                Get.back(result: false);
                              } else {
                                Navigator.pop(dialogContext, false);
                              }
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Periksa Kembali',
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
                            onPressed: () {
                              onContinue?.call();
                              if (useGetBack) {
                                Get.back(result: true);
                              } else {
                                Navigator.pop(dialogContext, true);
                              }
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Kirim',
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

  static Future<bool?> showCancelActivityDialog(
    BuildContext context, {
    bool useGetBack = true,
    Function? onContinue,
  }) async {
    return showDialog<bool>(
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
                'BATALKAN AKTIVITAS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Apakah anda yakin ingin membatalkan aktivitas ini?',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              Text(
                'Aktivitas yang sudah dibatalkan tidak dapat dikembalikan',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
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
                              if (useGetBack) {
                                Get.back(result: false);
                              } else {
                                Navigator.pop(dialogContext, false);
                              }
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Kembali',
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
                                side: BorderSide(color: Colors.red, width: 1),
                              ),
                            ),
                            onPressed: () {
                              onContinue?.call();
                              if (useGetBack) {
                                Get.back(result: true);
                              } else {
                                Navigator.pop(dialogContext, true);
                              }
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Batalkan',
                                style: TextStyle(color: Colors.red),
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
