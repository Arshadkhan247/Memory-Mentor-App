// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';
import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart';

class CaregiverRelationScreen extends StatefulWidget {
  const CaregiverRelationScreen({Key? key}) : super(key: key);

  @override
  _CaregiverRelationScreenState createState() =>
      _CaregiverRelationScreenState();
}

class _CaregiverRelationScreenState extends State<CaregiverRelationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _caregiverIdController = TextEditingController();

  final bool _isLoading = false;
  bool isEmailFilled = false;
  bool _isValidCaregiverID = false;

  final RelationshipService _relationshipService = RelationshipService();

  bool validateCaregiverId(String caregiverId) {
    RegExp caregiverIdRegex = RegExp(r'^\d{2,4}$');
    return caregiverIdRegex.hasMatch(caregiverId);
  }

  Future<void> verifyCaregiver() async {
    if (_isValidCaregiverID) {
      String patientId = _auth.currentUser!.uid;

      bool isValidCaregiver = await _relationshipService
          .isValidCaregiverId(_caregiverIdController.text);

      if (isValidCaregiver) {
        await _relationshipService.createRelationship(
            _caregiverIdController.text, patientId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You are now in relation with the caregiver'),
            duration: Duration(seconds: 3),
          ),
        );

        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const PatientHomeScreen(),
            ),
          );
        });
      } else {
        log('Invalid caregiver ID. Please enter a valid ID.' as num).toString();
        // Add logic to show an error message to the user
      }
    } else {
      print('Invalid caregiver ID. Please enter a valid ID.');
      // Add logic to show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid caregiver ID. Please enter a valid ID.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF6789CA),
                  Color(0xff281537),
                ]),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Confirm\nCaregivers',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Center(
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 300, maxWidth: 600),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    color: Colors.white,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormFieldWidget(
                            controller: _caregiverIdController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              setState(() {
                                isEmailFilled = value.isNotEmpty;
                                _isValidCaregiverID =
                                    validateCaregiverId(value);
                              });
                            },
                            suffixIcon: Icon(Icons.check,
                                color: _isValidCaregiverID
                                    ? Colors.green
                                    : Colors.grey),
                            fieldName: 'Caregiver ID',
                            obscureText: false),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: verifyCaregiver,
                          child: Container(
                            height: 55,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                Color(0xFF6789CA),
                                Color(0xff281537),
                              ]),
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: LoadingIndicator(
                                        indicatorType: Indicator.lineScale,
                                        colors: [Colors.white],
                                        strokeWidth: 0.5,
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      'Verify',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RelationshipService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isValidCaregiverId(String caregiverId) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String user = auth.currentUser!.uid;

      print(user.toString());
      DocumentSnapshot caregiverDoc =
          await _firestore.collection('users').doc(user).get();

      return caregiverDoc.exists;
    } catch (e) {
      print('Error checking caregiver ID: $e');
      return false;
    }
  }

  Future<void> createRelationship(String caregiverId, String patientId) async {
    try {
      // Use caregiverId as the document name
      await _firestore.collection('relationships').doc(caregiverId).set({
        'patientId': patientId,
        'caregiverId': caregiverId,
      });

      print('Relationship created successfully!');
    } catch (e) {
      print('Error creating relationship: $e');
    }
  }
}
