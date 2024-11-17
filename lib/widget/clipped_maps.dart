import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPreviewWidget extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  final double borderRadius;
  final double width;
  final double height;

  const MapPreviewWidget({
    Key? key,
    required this.latitude,
    required this.longitude,
    this.zoom = 14.0,
    this.borderRadius = 16.0,
    this.width = double.infinity,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: FlutterMap(
          options: MapOptions(
            // interactiveFlags: InteractiveFlag.none, // Disable all interactions
            initialCenter: LatLng(latitude, longitude),
            initialZoom: zoom,

          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            // Optional: Add a marker
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(latitude, longitude),
                  width: 80,
                  height: 80,
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}