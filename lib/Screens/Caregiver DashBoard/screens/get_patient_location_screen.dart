// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/User%20Dashboard/helper/text_styling.dart';

class GetPatientLocationScreen extends StatefulWidget {
  const GetPatientLocationScreen({Key? key}) : super(key: key);

  @override
  _GetPatientLocationScreenState createState() =>
      _GetPatientLocationScreenState();
}

class _GetPatientLocationScreenState extends State<GetPatientLocationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _user;
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
      _addCurrentLocationToFirebase(position, place);
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

  void _addCurrentLocationToFirebase(Position position, Placemark place) {
    if (_user != null) {
      _firestore.collection('locations').add({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'userId': _user!.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'country': place.country,
        'administrativeArea': place.administrativeArea,
        'locality': place.locality,
        'subLocality': place.subLocality,
      }).then((value) {
        _showSnackbar('Location added to Firebase successfully');
      }).catchError((error) {
        print('Error adding location to Firebase: $error');
        _showSnackbar('Error adding location to Firebase');
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.yellow,
        content: Text(message),
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
    _timer = Timer.periodic(const Duration(minutes: 10), (Timer timer) {
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
          'Patient Current Location',
          style: headingTextStyling,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 2,
                child: Image(
                  fit: BoxFit.fill,
                  height: 350,
                  width: double.infinity,
                  image: AssetImage(
                    'assets/googlemapimage.png',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (_currentPosition != null)
              Container(
                height: 100,
                width: 340,
                decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Patient Coordinates',
                        style: headingTextStyling,
                      ),
                      Text(
                        'Latitude       &    Longnitude\n${_currentPosition!.latitude}  ||   ${_currentPosition!.longitude}',
                        style: textStyling,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            if (_currentLocationDetails != null)
              Container(
                height: 150,
                width: 340,
                decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Patient Location Details',
                        style: headingTextStyling,
                      ),
                      Text(
                        'Country: ${_currentLocationDetails!.country},\nProvince: ${_currentLocationDetails!.administrativeArea},\nCity: ${_currentLocationDetails!.locality},\nSublocality: ${_currentLocationDetails!.subLocality}',
                        style: textStyling,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _getCurrentLocation();
              },
              child: Container(
                height: 50,
                width: 340,
                decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Get Current Location',
                    style: textStyling,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
