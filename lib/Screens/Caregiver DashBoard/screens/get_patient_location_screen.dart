import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Get extends StatefulWidget {
  const Get({Key? key}) : super(key: key);

  @override
  _GetState createState() => _GetState();
}

class _GetState extends State<Get> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? userId;
  String? patientId;
  Map<String, double> latLong = {};

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      userId = await _getUserIdFromFirestore();
      patientId = await fetchData();
      latLong = await getPatientLocation();
      setState(() {}); // Trigger a rebuild after obtaining userId
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  Future<String?> _getUserIdFromFirestore() async {
    try {
      String userUid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();

      if (userDoc.exists) {
        return userDoc['userId']?.toString();
      } else {
        print('User document does not exist in Firestore.');
        return null;
      }
    } catch (e) {
      print('Error getting user ID from Firestore: $e');
      return null;
    }
  }

  // with help of this class i get the patient id which are in relation with the corresponding caregiver.

  Future<String?> fetchData() async {
    try {
      DocumentSnapshot relationshipDoc = await FirebaseFirestore.instance
          .collection('relationships')
          .doc(userId)
          .get();

      String? patientId =
          relationshipDoc.exists ? relationshipDoc.get('patientId') : null;

      if (patientId != null) {
        print('Patient ID: $patientId');
        // Perform any actions with the patientId
        return patientId;
      } else {
        print('Patient ID not found for the caregiver.');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return null;
  }

  ///..............

  Future<Map<String, double>> getPatientLocation() async {
    try {
      DocumentSnapshot locationDoc = await FirebaseFirestore.instance
          .collection('patient_location')
          .doc(patientId)
          .get();

      if (locationDoc.exists) {
        double latitude = locationDoc.get('latitude');
        double longitude = locationDoc.get('longitude');

        return {'latitude': latitude, 'longitude': longitude};
      } else {
        print('Patient location not found for the given patientId.');
        return {};
      }
    } catch (e) {
      print('Error fetching patient location: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            latLong['latitude']!,
            latLong['longitude']!,
          ),
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          controller = controller;
        },
        markers: {
          Marker(
            markerId: const MarkerId('marker_1'),
            position: LatLng(
              latLong['latitude']!,
              latLong['longitude']!,
            ),
            infoWindow: const InfoWindow(
              snippet: 'Patient Location',
            ),
          ),
        },
      ),
    );
  }
}
