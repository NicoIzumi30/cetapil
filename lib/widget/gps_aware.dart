import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controller/gps_controller.dart';

class GPSAwareScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final bool requiresGPS;
  final Widget? bottomNavigationBar;
  final GPSLocationController gpsController = Get.find<GPSLocationController>();

  GPSAwareScaffold({
    Key? key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.requiresGPS = false,
  }) : super(key: key);

  void _showGPSDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.gps_off, color: Colors.red),
              SizedBox(width: 10),
              Text('GPS Required'),
            ],
          ),
          content: Text('GPS is required. Please enable GPS to use all features.'),
          actions: <Widget>[
            TextButton(
              child: Text('ENABLE'),
              onPressed: () async {
                Navigator.of(context).pop();
                bool activated = await gpsController.requestGPSActivation();
                if (!activated) {
                  _showGPSDialog(context); // Show dialog again if activation failed
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SafeArea(
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
                Expanded(child: body),
                bottomNavigationBar!
              ],
            ),
            if (requiresGPS)
              Obx(() {
                if (!gpsController.isGPSEnabled.value) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showGPSDialog(context);
                  });
                }
                return SizedBox.shrink();
              }),
          ],
        ),
      ),
      // bottomNavigationBar: bottomNavigationBar,
    );
  }
}
