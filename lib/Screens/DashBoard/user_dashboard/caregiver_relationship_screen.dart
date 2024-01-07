import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';
import 'package:mentor/Screens/DashBoard/user_dashboard/user_dashboard.dart';

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

  // Create an instance of the RelationshipService class
  final RelationshipService _relationshipService = RelationshipService();

  // Function to validate Caregiver ID
  bool validateCaregiverId(String caregiverId) {
    RegExp caregiverIdRegex = RegExp(r'^\d{2,4}$');
    return caregiverIdRegex.hasMatch(caregiverId);
  }

  // Function to handle the verification button tap
  Future<void> verifyCaregiver() async {
    if (_isValidCaregiverID) {
      // Replace 'patientId' with the actual patient ID (you need to obtain it from somewhere)
      String patientId =
          _auth.currentUser!.uid; // Replace this with the actual patient ID

      // Call the function to check if the caregiver ID is valid
      bool isValidCaregiver = await _relationshipService
          .isValidCaregiverId(_caregiverIdController.text);

      if (isValidCaregiver) {
        // If the caregiver ID is valid, create a relationship
        await _relationshipService.createRelationship(
            _caregiverIdController.text, patientId);

        print('Relationship created successfully!');
        // Add navigation logic or show a success message
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const UserDashboard(),
          ),
        );
      } else {
        // Handle the case where the caregiver ID is not valid
        print('Invalid caregiver ID. Please enter a valid ID.');
        // Add logic to show an error message to the user
      }
    } else {
      // Handle the case where the caregiver ID is not valid
      print('Invalid caregiver ID. Please enter a valid ID.');
      // Add logic to show an error message to the user
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

  // Function to check if the entered caregiver ID exists in Firestore
  Future<bool> isValidCaregiverId(String caregiverId) async {
    try {
      // Get the document associated with the caregiver ID
      FirebaseAuth auth = FirebaseAuth.instance;
      String user = auth.currentUser!.uid;
      DocumentSnapshot caregiverDoc =
          await _firestore.collection('users').doc(user).get();

      // Check if the document exists (meaning the caregiver ID is valid)
      return caregiverDoc.exists;
    } catch (e) {
      print('Error checking caregiver ID: $e');
      // Return false in case of an error (consider handling errors more gracefully)
      return false;
    }
  }

  // Function to create a relationship between caregiver and patient
  Future<void> createRelationship(String caregiverId, String patientId) async {
    try {
      // Create a new document in the relationships collection
      await _firestore.collection('relationships').add({
        'caregiverId': caregiverId,
        'patientId': patientId,
        // You can add more fields here if needed
      });

      print('Relationship created successfully!');
    } catch (e) {
      print('Error creating relationship: $e');
      // Handle the error as needed
    }
  }
}
