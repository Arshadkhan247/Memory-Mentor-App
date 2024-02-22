// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? _controller;

  static const LatLng _initialPosition =
      LatLng(37.7749, -122.4194); // San Francisco

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map Example'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _initialPosition,
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: {
          const Marker(
            markerId: MarkerId('marker_1'),
            position: _initialPosition,
            infoWindow: InfoWindow(
              title: 'San Francisco',
              snippet: 'A cool place!',
            ),
          ),
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _controller?.animateCamera(
                CameraUpdate.zoomIn(),
              );
            },
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _controller?.animateCamera(
                CameraUpdate.zoomOut(),
              );
            },
            child: const Icon(Icons.zoom_out),
          ),
        ],
      ),
    );
  }
}
