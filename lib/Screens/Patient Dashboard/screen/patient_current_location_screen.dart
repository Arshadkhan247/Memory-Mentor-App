import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mentor/Screens/Patient%20Dashboard/helper/text_styling.dart';

class PatientCurrentLocationScreen extends StatefulWidget {
  const PatientCurrentLocationScreen({Key? key}) : super(key: key);

  @override
  _PatientCurrentLocationScreenState createState() =>
      _PatientCurrentLocationScreenState();
}

class _PatientCurrentLocationScreenState
    extends State<PatientCurrentLocationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GoogleMapController? controller;
  User? _user;
  Position? _currentPosition;
  Placemark? _currentLocationDetails;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _startPeriodicUpdate();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool locationPermissionGranted = await _handleLocationPermission();

      if (!locationPermissionGranted) {
        _showErrorDialog('Location permission not granted.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;

      setState(() {
        _currentPosition = position;
        _currentLocationDetails = place;
      });

      _updateLocationInFirestore(position, place);
    } catch (e) {
      print('Error getting location: $e');
      _showErrorDialog('Error getting location: $e');
    }
  }

  Future<bool> _handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _showErrorDialog('Location permission not granted.');
        return false;
      }
    }

    return true;
  }

  void _updateLocationInFirestore(Position position, Placemark place) {
    if (_user != null) {
      _firestore.collection('patient_location').doc(_user!.uid).set({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'userId': _user!.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'country': place.country,
        'administrativeArea': place.administrativeArea,
        'locality': place.locality,
        'subLocality': place.subLocality,
      }).then((value) {
        _showSnackbar('Location uploaded to Firestore successfully');
      }).catchError((error) {
        print('Error uploading location to Firestore: $error');
        _showSnackbar('Error uploading location to Firestore');
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green.shade100,
        content: Text(
          message,
          style: TextStyle(color: Colors.green.shade900),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _startPeriodicUpdate() {
    _getCurrentLocation(); // Initial update
    _timer = Timer.periodic(const Duration(seconds: 60), (Timer timer) {
      _getCurrentLocation(); // Periodic update
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(
          0xffD9D9D9,
        ),
        centerTitle: true,
        title: Text(
          'Your Current Location',
          style: headingTextStyling,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: _currentPosition != null
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      zoom: 14.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      controller = controller;
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('marker_1'),
                        position: LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude),
                        infoWindow: InfoWindow(
                          title: (_currentLocationDetails?.subLocality) ?? '',
                          snippet: 'Patient Location',
                        ),
                      ),
                    },
                  )
                : const Center(
                    child:
                        CircularProgressIndicator(), // or any other loading indicator
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
