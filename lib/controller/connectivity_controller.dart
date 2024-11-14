import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ConnectivityController extends GetxController {
  final Rx<List<ConnectivityResult>> _connectionStatus = Rx<List<ConnectivityResult>>([]);

  List<ConnectivityResult> get connectionStatus => _connectionStatus.value;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await Connectivity().checkConnectivity();
    } catch (e) {
      print('Couldn\'t check connectivity status: $e');
      return;
    }
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    _connectionStatus.value = result;
  }

  bool get isConnected {
    if (kIsWeb) {
      // For web, we assume it's always connected when the app is running
      return true;
    } else {
      return _connectionStatus.value.contains(ConnectivityResult.wifi) ||
             _connectionStatus.value.contains(ConnectivityResult.mobile) ||
             _connectionStatus.value.contains(ConnectivityResult.ethernet);
    }
  }
}