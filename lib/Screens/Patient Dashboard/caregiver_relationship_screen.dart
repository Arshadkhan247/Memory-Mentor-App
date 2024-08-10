// // ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart';

// class CaregiverRelationScreen extends StatefulWidget {
//   const CaregiverRelationScreen({super.key});

//   @override
//   _CaregiverRelationScreenState createState() =>
//       _CaregiverRelationScreenState();
// }

// class _CaregiverRelationScreenState extends State<CaregiverRelationScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _caregiverIdController = TextEditingController();

//   final bool _isLoading = false;
//   bool isEmailFilled = false;
//   bool _isValidCaregiverID = false;

//   final RelationshipService _relationshipService = RelationshipService();

//   bool validateCaregiverId(String caregiverId) {
//     RegExp caregiverIdRegex = RegExp(r'^\d{2,4}$');
//     return caregiverIdRegex.hasMatch(caregiverId);
//   }

//   Future<void> verifyCaregiver() async {
//     if (_isValidCaregiverID) {
//       String patientId = _auth.currentUser!.uid;

//       bool isValidCaregiver = await _relationshipService
//           .isValidCaregiverId(_caregiverIdController.text);

//       if (isValidCaregiver) {
//         await _relationshipService.createRelationship(
//             _caregiverIdController.text, patientId);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('You are now in relation with the caregiver'),
//             duration: Duration(seconds: 3),
//           ),
//         );

//         Future.delayed(const Duration(seconds: 3), () {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) => const PatientHomeScreen(),
//             ),
//           );
//         });
//       } else {
//         log('Invalid caregiver ID. Please enter a valid ID.' as num).toString();
//         // Add logic to show an error message to the user
//       }
//     } else {
//       print('Invalid caregiver ID. Please enter a valid ID.');
//       // Add logic to show an error message to the user
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Invalid caregiver ID. Please enter a valid ID.'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//             Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(colors: [
//                   Color(0xFF6789CA),
//                   Color(0xff281537),
//                 ]),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.only(top: 60.0, left: 22),
//                 child: Text(
//                   'Confirm\nCaregivers',
//                   style: TextStyle(
//                       fontSize: 30,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 200.0),
//               child: Center(
//                 child: Container(
//                   constraints:
//                       const BoxConstraints(minWidth: 300, maxWidth: 600),
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(40),
//                         topRight: Radius.circular(40)),
//                     color: Colors.white,
//                   ),
//                   height: double.infinity,
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 18.0, right: 18),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextFormFieldWidget(
//                             controller: _caregiverIdController,
//                             keyboardType: TextInputType.emailAddress,
//                             onChanged: (value) {
//                               setState(() {
//                                 isEmailFilled = value.isNotEmpty;
//                                 _isValidCaregiverID =
//                                     validateCaregiverId(value);
//                               });
//                             },
//                             suffixIcon: Icon(Icons.check,
//                                 color: _isValidCaregiverID
//                                     ? Colors.green
//                                     : Colors.grey),
//                             fieldName: 'Caregiver ID',
//                             obscureText: false),
//                         const SizedBox(
//                           height: 15,
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         GestureDetector(
//                           onTap: verifyCaregiver,
//                           child: Container(
//                             height: 55,
//                             width: 300,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               gradient: const LinearGradient(colors: [
//                                 Color(0xFF6789CA),
//                                 Color(0xff281537),
//                               ]),
//                             ),
//                             child: _isLoading
//                                 ? const Center(
//                                     child: Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: LoadingIndicator(
//                                         indicatorType: Indicator.lineScale,
//                                         colors: [Colors.white],
//                                         strokeWidth: 0.5,
//                                         backgroundColor: Colors.transparent,
//                                       ),
//                                     ),
//                                   )
//                                 : const Center(
//                                     child: Text(
//                                       'Verify',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RelationshipService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<bool> isValidCaregiverId(String caregiverId) async {
//     try {
//       FirebaseAuth auth = FirebaseAuth.instance;
//       String user = auth.currentUser!.uid;

//       print(user.toString());
//       DocumentSnapshot caregiverDoc =
//           await _firestore.collection('users').doc(user).get();

//       return caregiverDoc.exists;
//     } catch (e) {
//       print('Error checking caregiver ID: $e');
//       return false;
//     }
//   }

//   Future<void> createRelationship(String caregiverId, String patientId) async {
//     try {
//       var docId = caregiverId + patientId;
//       // Use caregiverId as the document name
//       await _firestore.collection('relationships').doc(docId).set({
//         'patientId': patientId,
//         'caregiverId': caregiverId,
//       });

//       print('Relationship created successfully!');
//     } catch (e) {
//       print('Error creating relationship: $e');
//     }
//   }
// }

// // // ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

// // import 'dart:math';
// // import 'package:flutter/material.dart';
// // import 'package:loading_indicator/loading_indicator.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';
// // import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart';

// // class CaregiverRelationScreen extends StatefulWidget {
// //   const CaregiverRelationScreen({super.key});

// //   @override
// //   _CaregiverRelationScreenState createState() =>
// //       _CaregiverRelationScreenState();
// // }

// // class _CaregiverRelationScreenState extends State<CaregiverRelationScreen> {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final TextEditingController _caregiverIdController = TextEditingController();
// //   bool _isLoading = false;
// //   bool isEmailFilled = false;
// //   bool _isValidCaregiverID = false;
// //   final RelationshipService _relationshipService = RelationshipService();

// //   bool validateCaregiverId(String caregiverId) {
// //     RegExp caregiverIdRegex = RegExp(r'^\d{2,4}$');
// //     return caregiverIdRegex.hasMatch(caregiverId);
// //   }

// //   Future<void> verifyCaregiver() async {
// //     setState(() {
// //       _isLoading = true;
// //     });

// //     if (_isValidCaregiverID) {
// //       String patientId = _auth.currentUser!.uid;

// //       bool isValidCaregiver = await _relationshipService
// //           .isValidCaregiverId(_caregiverIdController.text);

// //       if (isValidCaregiver) {
// //         await _relationshipService.createRelationship(
// //             _caregiverIdController.text, patientId);

// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('You are now in relation with the caregiver'),
// //             duration: Duration(seconds: 3),
// //           ),
// //         );

// //         Future.delayed(const Duration(seconds: 3), () {
// //           Navigator.of(context).pushReplacement(
// //             MaterialPageRoute(
// //               builder: (context) => const PatientHomeScreen(),
// //             ),
// //           );
// //         });
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Invalid caregiver ID. Please enter a valid ID.'),
// //             duration: Duration(seconds: 3),
// //           ),
// //         );
// //       }
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Invalid caregiver ID. Please enter a valid ID.'),
// //           duration: Duration(seconds: 3),
// //         ),
// //       );
// //     }

// //     setState(() {
// //       _isLoading = false;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: () {
// //         FocusScope.of(context).unfocus();
// //       },
// //       child: Scaffold(
// //         resizeToAvoidBottomInset: false,
// //         body: Stack(
// //           children: [
// //             Container(
// //               height: double.infinity,
// //               width: double.infinity,
// //               decoration: const BoxDecoration(
// //                 gradient: LinearGradient(colors: [
// //                   Color(0xFF6789CA),
// //                   Color(0xff281537),
// //                 ]),
// //               ),
// //               child: const Padding(
// //                 padding: EdgeInsets.only(top: 60.0, left: 22),
// //                 child: Text(
// //                   'Confirm\nCaregivers',
// //                   style: TextStyle(
// //                       fontSize: 30,
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.bold),
// //                 ),
// //               ),
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.only(top: 200.0),
// //               child: Center(
// //                 child: Container(
// //                   constraints:
// //                       const BoxConstraints(minWidth: 300, maxWidth: 600),
// //                   decoration: const BoxDecoration(
// //                     borderRadius: BorderRadius.only(
// //                         topLeft: Radius.circular(40),
// //                         topRight: Radius.circular(40)),
// //                     color: Colors.white,
// //                   ),
// //                   height: double.infinity,
// //                   width: double.infinity,
// //                   child: Padding(
// //                     padding: const EdgeInsets.only(left: 18.0, right: 18),
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         TextFormFieldWidget(
// //                             controller: _caregiverIdController,
// //                             keyboardType: TextInputType.emailAddress,
// //                             onChanged: (value) {
// //                               setState(() {
// //                                 isEmailFilled = value.isNotEmpty;
// //                                 _isValidCaregiverID =
// //                                     validateCaregiverId(value);
// //                               });
// //                             },
// //                             suffixIcon: Icon(Icons.check,
// //                                 color: _isValidCaregiverID
// //                                     ? Colors.green
// //                                     : Colors.grey),
// //                             fieldName: 'Caregiver ID',
// //                             obscureText: false),
// //                         const SizedBox(
// //                           height: 15,
// //                         ),
// //                         const SizedBox(
// //                           height: 30,
// //                         ),
// //                         GestureDetector(
// //                           onTap: verifyCaregiver,
// //                           child: Container(
// //                             height: 55,
// //                             width: 300,
// //                             decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(30),
// //                               gradient: const LinearGradient(colors: [
// //                                 Color(0xFF6789CA),
// //                                 Color(0xff281537),
// //                               ]),
// //                             ),
// //                             child: _isLoading
// //                                 ? const Center(
// //                                     child: Padding(
// //                                       padding: EdgeInsets.all(8.0),
// //                                       child: LoadingIndicator(
// //                                         indicatorType: Indicator.lineScale,
// //                                         colors: [Colors.white],
// //                                         strokeWidth: 0.5,
// //                                         backgroundColor: Colors.transparent,
// //                                       ),
// //                                     ),
// //                                   )
// //                                 : const Center(
// //                                     child: Text(
// //                                       'Verify',
// //                                       style: TextStyle(
// //                                           fontWeight: FontWeight.bold,
// //                                           fontSize: 20,
// //                                           color: Colors.white),
// //                                     ),
// //                                   ),
// //                           ),
// //                         ),
// //                         const SizedBox(
// //                           height: 30,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class RelationshipService {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// //   Future<bool> isValidCaregiverId(String caregiverId) async {
// //     try {
// //       DocumentSnapshot caregiverDoc =
// //           await _firestore.collection('users').doc(caregiverId).get();

// //       return caregiverDoc.exists;
// //     } catch (e) {
// //       print('Error checking caregiver ID: $e');
// //       return false;
// //     }
// //   }

// //   Future<void> createRelationship(String caregiverId, String patientId) async {
// //     try {
// //       // Use caregiverId and patientId to create a unique document name
// //       await _firestore
// //           .collection('relationships')
// //           .doc('$caregiverId$patientId')
// //           .set({
// //         'patientId': patientId,
// //         'caregiverId': caregiverId,
// //       });

// //       print('Relationship created successfully!');
// //     } catch (e) {
// //       print('Error creating relationship: $e');
// //     }
// //   }
// // }

// <<<<<<<<<<<<<<<<<    Woring Code  >>>>>>>>>>>>>>>

// // ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart';

// class CaregiverRelationScreen extends StatefulWidget {
//   const CaregiverRelationScreen({super.key});

//   @override
//   _CaregiverRelationScreenState createState() =>
//       _CaregiverRelationScreenState();
// }

// class _CaregiverRelationScreenState extends State<CaregiverRelationScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _caregiverIdController = TextEditingController();

//   bool _isLoading = false;
//   bool isEmailFilled = false;
//   bool _isValidCaregiverID = false;
//   var caregiverUid;
//   var caregiverName;

//   final RelationshipService _relationshipService = RelationshipService();

//   bool validateCaregiverId(String caregiverId) {
//     RegExp caregiverIdRegex = RegExp(r'^\d{2,4}$');
//     return caregiverIdRegex.hasMatch(caregiverId);
//   }

//   Future<void> verifyCaregiver() async {
//     setState(() {
//       _isLoading = true;
//     });

//     if (_isValidCaregiverID) {
//       String patientId = _auth.currentUser!.uid;

//       DocumentSnapshot? caregiverData = await _relationshipService
//           .getCaregiverDataById(_caregiverIdController.text);

//       if (caregiverData != null) {
//         caregiverUid = caregiverData.id;
//         caregiverName = caregiverData['userName'];

//         print(caregiverUid.toString());
//         print(caregiverName.toString());

//         await _relationshipService.createRelationship(
//             _caregiverIdController.text,
//             patientId,
//             caregiverUid,
//             caregiverName);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('You are now in relation with the caregiver'),
//             duration: Duration(seconds: 3),
//           ),
//         );

//         Future.delayed(const Duration(seconds: 3), () {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) => PatientHomeScreen(
//                 caregiverId: _caregiverIdController.text,
//               ),
//             ),
//           );
//         });
//       } else {
//         log('Invalid caregiver ID. Please enter a valid ID.');
//         // Add logic to show an error message to the user
//       }
//     } else {
//       print('Invalid caregiver ID. Please enter a valid ID.');
//       // Add logic to show an error message to the user
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Invalid caregiver ID. Please enter a valid ID.'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//             Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(colors: [
//                   Color(0xFF6789CA),
//                   Color(0xff281537),
//                 ]),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.only(top: 60.0, left: 22),
//                 child: Text(
//                   'Confirm\nCaregivers',
//                   style: TextStyle(
//                       fontSize: 30,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 200.0),
//               child: Center(
//                 child: Container(
//                   constraints:
//                       const BoxConstraints(minWidth: 300, maxWidth: 600),
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(40),
//                         topRight: Radius.circular(40)),
//                     color: Colors.white,
//                   ),
//                   height: double.infinity,
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 18.0, right: 18),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextFormFieldWidget(
//                             controller: _caregiverIdController,
//                             keyboardType: TextInputType.emailAddress,
//                             onChanged: (value) {
//                               setState(() {
//                                 isEmailFilled = value.isNotEmpty;
//                                 _isValidCaregiverID =
//                                     validateCaregiverId(value);
//                               });
//                             },
//                             suffixIcon: Icon(Icons.check,
//                                 color: _isValidCaregiverID
//                                     ? Colors.green
//                                     : Colors.grey),
//                             fieldName: 'Caregiver ID',
//                             obscureText: false),
//                         const SizedBox(
//                           height: 15,
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         GestureDetector(
//                           onTap: verifyCaregiver,
//                           child: Container(
//                             height: 55,
//                             width: 300,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               gradient: const LinearGradient(colors: [
//                                 Color(0xFF6789CA),
//                                 Color(0xff281537),
//                               ]),
//                             ),
//                             child: _isLoading
//                                 ? const Center(
//                                     child: Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: LoadingIndicator(
//                                         indicatorType: Indicator.lineScale,
//                                         colors: [Colors.white],
//                                         strokeWidth: 0.5,
//                                         backgroundColor: Colors.transparent,
//                                       ),
//                                     ),
//                                   )
//                                 : const Center(
//                                     child: Text(
//                                       'Verify',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RelationshipService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<DocumentSnapshot?> getCaregiverDataById(String caregiverId) async {
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('users')
//           .where('userId', isEqualTo: caregiverId)
//           .get();

//       if (snapshot.docs.isNotEmpty) {
//         return snapshot.docs.first;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error checking caregiver ID: $e');
//       return null;
//     }
//   }

//   Future<void> createRelationship(
//     String caregiverId,
//     String patientId,
//     String currentUID,
//     String userName,
//   ) async {
//     try {
//       var docId = caregiverId + patientId;
//       // Use caregiverId as the document name
//       await _firestore.collection('relationships').doc(docId).set({
//         'patientId': patientId,
//         'caregiverId': caregiverId,
//         'currentUID': currentUID,
//         'userName': userName,
//       });

//       print('Relationship created successfully!');
//     } catch (e) {
//       print('Error creating relationship: $e');
//     }
//   }
// }

// // ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart';

// class CaregiverRelationScreen extends StatefulWidget {
//   const CaregiverRelationScreen({super.key});

//   @override
//   _CaregiverRelationScreenState createState() =>
//       _CaregiverRelationScreenState();
// }

// class _CaregiverRelationScreenState extends State<CaregiverRelationScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _caregiverIdController = TextEditingController();

//   bool _isLoading = false;
//   bool isEmailFilled = false;
//   bool _isValidCaregiverID = false;
//   var caregiverUid;
//   var caregiverName;

//   final RelationshipService _relationshipService = RelationshipService();

//   bool validateCaregiverId(String caregiverId) {
//     RegExp caregiverIdRegex = RegExp(r'^\d{2,4}$');
//     return caregiverIdRegex.hasMatch(caregiverId);
//   }

//   Future<void> verifyCaregiver() async {
//     setState(() {
//       _isLoading = true;
//     });

//     if (_isValidCaregiverID) {
//       String patientId = _auth.currentUser!.uid;

//       DocumentSnapshot? caregiverData = await _relationshipService
//           .getCaregiverDataById(_caregiverIdController.text);

//       if (caregiverData != null) {
//         caregiverUid = caregiverData.id;
//         caregiverName = caregiverData['userName'];

//         print(caregiverUid.toString());
//         print(caregiverName.toString());

//         await _relationshipService.createRelationship(
//             _caregiverIdController.text,
//             patientId,
//             caregiverUid,
//             caregiverName);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('You are now in relation with the caregiver'),
//             duration: Duration(seconds: 3),
//           ),
//         );

//         Future.delayed(const Duration(seconds: 3), () {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) => PatientHomeScreen(
//                 caregiverId: _caregiverIdController.text,
//               ),
//             ),
//           );
//         });
//       } else {
//         log('Invalid caregiver ID. Please enter a valid ID.');
//         // Add logic to show an error message to the user
//       }
//     } else {
//       print('Invalid caregiver ID. Please enter a valid ID.');
//       // Add logic to show an error message to the user
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Invalid caregiver ID. Please enter a valid ID.'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//             Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color.fromARGB(255, 38, 142, 226),
//                     Colors.white,
//                   ],
//                 ),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.only(top: 60.0, left: 22),
//                 child: Text(
//                   'Confirm\nCaregivers',
//                   style: TextStyle(
//                     fontSize: 30,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 200.0),
//               child: Center(
//                 child: Container(
//                   constraints:
//                       const BoxConstraints(minWidth: 300, maxWidth: 600),
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40),
//                     ),
//                     color: Colors.white,
//                   ),
//                   height: double.infinity,
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 18.0, right: 18),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextFormFieldWidget(
//                           controller: _caregiverIdController,
//                           keyboardType: TextInputType.emailAddress,
//                           onChanged: (value) {
//                             setState(() {
//                               isEmailFilled = value.isNotEmpty;
//                               _isValidCaregiverID = validateCaregiverId(value);
//                             });
//                           },
//                           suffixIcon: Icon(
//                             Icons.check,
//                             color: _isValidCaregiverID
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                           fieldName: 'Caregiver ID',
//                           obscureText: false,
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         GestureDetector(
//                           onTap: verifyCaregiver,
//                           child: Container(
//                             height: 55,
//                             width: 300,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               gradient: const LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Color.fromARGB(255, 38, 142, 226),
//                                   Color.fromARGB(255, 38, 142, 226),
//                                 ],
//                               ),
//                             ),
//                             child: _isLoading
//                                 ? const Center(
//                                     child: Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: LoadingIndicator(
//                                         indicatorType: Indicator.lineScale,
//                                         colors: [Colors.white],
//                                         strokeWidth: 0.5,
//                                         backgroundColor: Colors.transparent,
//                                       ),
//                                     ),
//                                   )
//                                 : const Center(
//                                     child: Text(
//                                       'Verify',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RelationshipService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<DocumentSnapshot?> getCaregiverDataById(String caregiverId) async {
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('users')
//           .where('userId', isEqualTo: caregiverId)
//           .get();

//       if (snapshot.docs.isNotEmpty) {
//         return snapshot.docs.first;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error checking caregiver ID: $e');
//       return null;
//     }
//   }

//   Future<void> createRelationship(
//     String caregiverId,
//     String patientId,
//     String currentUID,
//     String userName,
//   ) async {
//     try {
//       var docId = caregiverId + patientId;
//       // Use caregiverId as the document name
//       await _firestore.collection('relationships').doc(docId).set({
//         'patientId': patientId,
//         'caregiverId': caregiverId,
//         'currentUID': currentUID,
//         'userName': userName,
//       });

//       print('Relationship created successfully!');
//     } catch (e) {
//       print('Error creating relationship: $e');
//     }
//   }
// }

// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
// import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart';

// class CaregiverRelationScreen extends StatefulWidget {
//   const CaregiverRelationScreen({super.key});

//   @override
//   _CaregiverRelationScreenState createState() =>
//       _CaregiverRelationScreenState();
// }

// class _CaregiverRelationScreenState extends State<CaregiverRelationScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _caregiverIdController = TextEditingController();

//   bool _isLoading = false;
//   bool _isValidCaregiverID = false;
//   var caregiverUid;
//   var caregiverName;

//   final RelationshipService _relationshipService = RelationshipService();
//   String? _savedCaregiverId;

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedCaregiverId();
//   }

//   Future<void> _loadSavedCaregiverId() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _savedCaregiverId = prefs.getString('caregiverId');
//       if (_savedCaregiverId != null) {
//         _caregiverIdController.text = _savedCaregiverId!;
//         _isValidCaregiverID = validateCaregiverId(_savedCaregiverId!);
//       }
//     });
//   }

//   bool validateCaregiverId(String caregiverId) {
//     RegExp caregiverIdRegex = RegExp(r'^\d{2,4}$');
//     return caregiverIdRegex.hasMatch(caregiverId);
//   }

//   Future<void> verifyCaregiver() async {
//     setState(() {
//       _isLoading = true;
//     });

//     if (_isValidCaregiverID) {
//       String patientId = _auth.currentUser!.uid;

//       DocumentSnapshot? caregiverData = await _relationshipService
//           .getCaregiverDataById(_caregiverIdController.text);

//       if (caregiverData != null) {
//         caregiverUid = caregiverData.id;
//         caregiverName = caregiverData['userName'];

//         await _relationshipService.createRelationship(
//             _caregiverIdController.text,
//             patientId,
//             caregiverUid,
//             caregiverName);

//         // Save the caregiver ID to SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('caregiverId', _caregiverIdController.text);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('You are now in relation with the caregiver'),
//             duration: Duration(seconds: 3),
//           ),
//         );

//         Future.delayed(const Duration(seconds: 3), () {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) => PatientHomeScreen(
//                 caregiverId: _caregiverIdController.text,
//               ),
//             ),
//           );
//         });
//       } else {
//         log('Invalid caregiver ID. Please enter a valid ID.');
//         // Add logic to show an error message to the user
//       }
//     } else {
//       print('Invalid caregiver ID. Please enter a valid ID.');
//       // Add logic to show an error message to the user
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Invalid caregiver ID. Please enter a valid ID.'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//             Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color.fromARGB(255, 38, 142, 226),
//                     Colors.white,
//                   ],
//                 ),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.only(top: 60.0, left: 22),
//                 child: Text(
//                   'Confirm\nCaregivers',
//                   style: TextStyle(
//                     fontSize: 30,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 200.0),
//               child: Center(
//                 child: Container(
//                   constraints:
//                       const BoxConstraints(minWidth: 300, maxWidth: 600),
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40),
//                     ),
//                     color: Colors.white,
//                   ),
//                   height: double.infinity,
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 18.0, right: 18),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextFormFieldWidget(
//                           controller: _caregiverIdController,
//                           keyboardType: TextInputType.number,
//                           onChanged: (value) {
//                             setState(() {
//                               _isValidCaregiverID = validateCaregiverId(value);
//                             });
//                           },
//                           suffixIcon: Icon(
//                             Icons.check,
//                             color: _isValidCaregiverID
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                           fieldName: 'Caregiver ID',
//                           obscureText: false,
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         GestureDetector(
//                           onTap: verifyCaregiver,
//                           child: Container(
//                             height: 55,
//                             width: 300,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               gradient: const LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Color.fromARGB(255, 38, 142, 226),
//                                   Color.fromARGB(255, 38, 142, 226),
//                                 ],
//                               ),
//                             ),
//                             child: _isLoading
//                                 ? const Center(
//                                     child: Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: LoadingIndicator(
//                                         indicatorType: Indicator.lineScale,
//                                         colors: [Colors.white],
//                                         strokeWidth: 0.5,
//                                         backgroundColor: Colors.transparent,
//                                       ),
//                                     ),
//                                   )
//                                 : const Center(
//                                     child: Text(
//                                       'Verify',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RelationshipService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<DocumentSnapshot?> getCaregiverDataById(String caregiverId) async {
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('users')
//           .where('userId', isEqualTo: caregiverId)
//           .get();

//       if (snapshot.docs.isNotEmpty) {
//         return snapshot.docs.first;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error checking caregiver ID: $e');
//       return null;
//     }
//   }

//   Future<void> createRelationship(
//     String caregiverId,
//     String patientId,
//     String currentUID,
//     String userName,
//   ) async {
//     try {
//       var docId = caregiverId + patientId;
//       // Use caregiverId as the document name
//       await _firestore.collection('relationships').doc(docId).set({
//         'patientId': patientId,
//         'caregiverId': caregiverId,
//         'currentUID': currentUID,
//         'userName': userName,
//       });

//       print('Relationship created successfully!');
//     } catch (e) {
//       print('Error creating relationship: $e');
//     }
//   }
// }

// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
// import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart';

// class CaregiverRelationScreen extends StatefulWidget {
//   const CaregiverRelationScreen({super.key});

//   @override
//   _CaregiverRelationScreenState createState() =>
//       _CaregiverRelationScreenState();
// }

// class _CaregiverRelationScreenState extends State<CaregiverRelationScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _caregiverIdController = TextEditingController();

//   bool _isLoading = false;
//   bool _isValidCaregiverID = false;
//   var caregiverUid;
//   var caregiverName;

//   final RelationshipService _relationshipService = RelationshipService();
//   String? _savedCaregiverId;

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedCaregiverId();
//   }

//   Future<void> _loadSavedCaregiverId() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _savedCaregiverId = prefs.getString('caregiverId');
//       if (_savedCaregiverId != null) {
//         _caregiverIdController.text = _savedCaregiverId!;
//         _isValidCaregiverID = validateCaregiverId(_savedCaregiverId!);
//       }
//     });
//   }

//   bool validateCaregiverId(String caregiverId) {
//     RegExp caregiverIdRegex = RegExp(r'^\d{2,4}$');
//     return caregiverIdRegex.hasMatch(caregiverId);
//   }

//   Future<void> verifyCaregiver() async {
//     setState(() {
//       _isLoading = true;
//     });

//     if (_isValidCaregiverID) {
//       String patientId = _auth.currentUser!.uid;

//       DocumentSnapshot? caregiverData = await _relationshipService
//           .getCaregiverDataById(_caregiverIdController.text);

//       if (caregiverData != null) {
//         caregiverUid = caregiverData.id;
//         caregiverName = caregiverData['userName'];

//         await _relationshipService.createRelationship(
//             _caregiverIdController.text,
//             patientId,
//             caregiverUid,
//             caregiverName);

//         // Save the caregiver ID to SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('caregiverId', _caregiverIdController.text);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('You are now in relation with the caregiver'),
//             duration: Duration(seconds: 3),
//           ),
//         );

//         Future.delayed(const Duration(seconds: 3), () {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) => PatientHomeScreen(
//                 caregiverId: _caregiverIdController.text,
//               ),
//             ),
//           );
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Caregiver is already assigned to another patient.'),
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Invalid caregiver ID. Please enter a valid ID.'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//             Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color.fromARGB(255, 38, 142, 226),
//                     Colors.white,
//                   ],
//                 ),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.only(top: 60.0, left: 22),
//                 child: Text(
//                   'Confirm\nCaregivers',
//                   style: TextStyle(
//                     fontSize: 30,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 200.0),
//               child: Center(
//                 child: Container(
//                   constraints:
//                       const BoxConstraints(minWidth: 300, maxWidth: 600),
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40),
//                     ),
//                     color: Colors.white,
//                   ),
//                   height: double.infinity,
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 18.0, right: 18),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextFormFieldWidget(
//                           controller: _caregiverIdController,
//                           keyboardType: TextInputType.number,
//                           onChanged: (value) {
//                             setState(() {
//                               _isValidCaregiverID = validateCaregiverId(value);
//                             });
//                           },
//                           suffixIcon: Icon(
//                             Icons.check,
//                             color: _isValidCaregiverID
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                           fieldName: 'Caregiver ID',
//                           obscureText: false,
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         GestureDetector(
//                           onTap: verifyCaregiver,
//                           child: Container(
//                             height: 55,
//                             width: 300,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               gradient: const LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Color.fromARGB(255, 38, 142, 226),
//                                   Color.fromARGB(255, 38, 142, 226),
//                                 ],
//                               ),
//                             ),
//                             child: _isLoading
//                                 ? const Center(
//                                     child: Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: LoadingIndicator(
//                                         indicatorType: Indicator.lineScale,
//                                         colors: [Colors.white],
//                                         strokeWidth: 0.5,
//                                         backgroundColor: Colors.transparent,
//                                       ),
//                                     ),
//                                   )
//                                 : const Center(
//                                     child: Text(
//                                       'Verify',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RelationshipService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<DocumentSnapshot?> getCaregiverDataById(String caregiverId) async {
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('users')
//           .where('userId', isEqualTo: caregiverId)
//           .get();

//       if (snapshot.docs.isNotEmpty) {
//         // Fetch any existing relationship for the caregiver
//         QuerySnapshot relationshipSnapshot = await _firestore
//             .collection('relationships')
//             .where('caregiverId', isEqualTo: caregiverId)
//             .get();

//         if (relationshipSnapshot.docs.isNotEmpty) {
//           // Caregiver is already assigned to another patient
//           return null;
//         } else {
//           return snapshot.docs.first;
//         }
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error checking caregiver ID: $e');
//       return null;
//     }
//   }

//   Future<void> createRelationship(
//     String caregiverId,
//     String patientId,
//     String currentUID,
//     String caregiverUserName,
//   ) async {
//     try {
//       var docId = caregiverId;
//       // Use caregiverId as the document name
//       await _firestore.collection('relationships').doc(docId).set({
//         'patientId': patientId,
//         'caregiverId': caregiverId,
//         'currentUID': currentUID,
//         'caregiverUserName': caregiverUserName,
//       });

//       print('Relationship created successfully!');
//     } catch (e) {
//       print('Error creating relationship: $e');
//     }
//   }
// }

// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
// import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart';

// class CaregiverRelationScreen extends StatefulWidget {
//   const CaregiverRelationScreen({super.key});

//   @override
//   _CaregiverRelationScreenState createState() =>
//       _CaregiverRelationScreenState();
// }

// class _CaregiverRelationScreenState extends State<CaregiverRelationScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   final TextEditingController _caregiverIdController = TextEditingController();
//   bool _isLoading = false;
//   bool _isValidCaregiverID = false;
//   var caregiverUid;
//   var caregiverName;
//   String? _savedCaregiverId;

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedCaregiverId();
//   }

//   Future<void> _loadSavedCaregiverId() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _savedCaregiverId = prefs.getString('caregiverId');
//       if (_savedCaregiverId != null) {
//         _caregiverIdController.text = _savedCaregiverId!;
//         _isValidCaregiverID = validateCaregiverId(_savedCaregiverId!);
//       }
//     });
//   }

//   bool validateCaregiverId(String caregiverId) {
//     RegExp caregiverIdRegex = RegExp(r'^\d{2,4}$');
//     return caregiverIdRegex.hasMatch(caregiverId);
//   }

//   Future<DocumentSnapshot?> _getCaregiverDataById(String caregiverId) async {
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('users')
//           .where('userId', isEqualTo: caregiverId)
//           .get();

//       if (snapshot.docs.isNotEmpty) {
//         // Fetch any existing relationship for the caregiver
//         QuerySnapshot relationshipSnapshot = await _firestore
//             .collection('relationships')
//             .where('caregiverId', isEqualTo: caregiverId)
//             .get();

//         if (relationshipSnapshot.docs.isNotEmpty) {
//           // Caregiver is already assigned to another patient
//           return null;
//         } else {
//           return snapshot.docs.first;
//         }
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error checking caregiver ID: $e');
//       return null;
//     }
//   }

//   Future<DocumentSnapshot> _getPatientDataById(String patientId) async {
//     try {
//       return await _firestore.collection('users').doc(patientId).get();
//     } catch (e) {
//       print('Error getting patient data: $e');
//       rethrow;
//     }
//   }

//   Future<void> _createRelationship(
//     String caregiverId,
//     String patientId,
//     String currentUID,
//     String caregiverUserName,
//     String patientUserName,
//   ) async {
//     try {
//       await _firestore.collection('relationships').doc(caregiverId).set({
//         'patientId': patientId,
//         'caregiverId': caregiverId,
//         'currentUID': currentUID,
//         'caregiverUserName': caregiverUserName,
//         'patientUserName': patientUserName,
//       });

//       print('Relationship created successfully!');
//     } catch (e) {
//       print('Error creating relationship: $e');
//     }
//   }

//   Future<void> _verifyCaregiver() async {
//     setState(() {
//       _isLoading = true;
//     });

//     if (_isValidCaregiverID) {
//       String patientId = _auth.currentUser!.uid;

//       // Fetch the patient (current user) username
//       DocumentSnapshot patientDoc = await _getPatientDataById(patientId);
//       String patientUserName = patientDoc['userName'];

//       DocumentSnapshot? caregiverData =
//           await _getCaregiverDataById(_caregiverIdController.text);

//       if (caregiverData != null) {
//         caregiverUid = caregiverData.id;
//         caregiverName = caregiverData['userName'];

//         await _createRelationship(
//           _caregiverIdController.text,
//           patientId,
//           caregiverUid,
//           caregiverName,
//           patientUserName, // Pass the patient's username
//         );

//         // Save the caregiver ID to SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('caregiverId', _caregiverIdController.text);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('You are now in relation with the caregiver'),
//             duration: Duration(seconds: 3),
//           ),
//         );

//         Future.delayed(const Duration(seconds: 3), () {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) => PatientHomeScreen(
//                 caregiverId: _caregiverIdController.text,
//               ),
//             ),
//           );
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Caregiver is already assigned to another patient.'),
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Invalid caregiver ID. Please enter a valid ID.'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//             Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color.fromARGB(255, 38, 142, 226),
//                     Colors.white,
//                   ],
//                 ),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.only(top: 60.0, left: 22),
//                 child: Text(
//                   'Confirm\nCaregivers',
//                   style: TextStyle(
//                     fontSize: 30,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 200.0),
//               child: Center(
//                 child: Container(
//                   constraints:
//                       const BoxConstraints(minWidth: 300, maxWidth: 600),
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40),
//                     ),
//                     color: Colors.white,
//                   ),
//                   height: double.infinity,
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 18.0, right: 18),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextFormFieldWidget(
//                           controller: _caregiverIdController,
//                           keyboardType: TextInputType.number,
//                           onChanged: (value) {
//                             setState(() {
//                               _isValidCaregiverID = validateCaregiverId(value);
//                             });
//                           },
//                           suffixIcon: Icon(
//                             Icons.check,
//                             color: _isValidCaregiverID
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                           fieldName: 'Caregiver ID',
//                           obscureText: false,
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         GestureDetector(
//                           onTap: _verifyCaregiver,
//                           child: Container(
//                             height: 55,
//                             width: 300,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               gradient: const LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Color.fromARGB(255, 38, 142, 226),
//                                   Color.fromARGB(255, 38, 142, 226),
//                                 ],
//                               ),
//                             ),
//                             child: _isLoading
//                                 ? const Center(
//                                     child: Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: LoadingIndicator(
//                                         indicatorType: Indicator.lineScale,
//                                         colors: [Colors.white],
//                                         strokeWidth: 0.5,
//                                         backgroundColor: Colors.transparent,
//                                       ),
//                                     ),
//                                   )
//                                 : const Center(
//                                     child: Text(
//                                       'Verify',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
// import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart';

// class CaregiverRelationScreen extends StatefulWidget {
//   const CaregiverRelationScreen({super.key});

//   @override
//   _CaregiverRelationScreenState createState() =>
//       _CaregiverRelationScreenState();
// }

// class _CaregiverRelationScreenState extends State<CaregiverRelationScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   final TextEditingController _caregiverIdController = TextEditingController();
//   bool _isLoading = false;
//   bool _isValidCaregiverID = false;
//   var caregiverUid;
//   var caregiverName;
//   String? _savedCaregiverId;

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedCaregiverId();
//   }

//   Future<void> _loadSavedCaregiverId() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _savedCaregiverId = prefs.getString('caregiverId');
//       if (_savedCaregiverId != null) {
//         _caregiverIdController.text = _savedCaregiverId!;
//         _isValidCaregiverID = validateCaregiverId(_savedCaregiverId!);
//       }
//     });
//   }

//   bool validateCaregiverId(String caregiverId) {
//     RegExp caregiverIdRegex = RegExp(r'^\d{2,4}$');
//     return caregiverIdRegex.hasMatch(caregiverId);
//   }

//   Future<dynamic> _getCaregiverDataById(String caregiverId) async {
//     try {
//       // Fetch caregiver data
//       DocumentSnapshot caregiverSnapshot = await _firestore
//           .collection('users')
//           .doc(caregiverId)
//           .get();

//       if (caregiverSnapshot.exists) {
//         // Fetch existing relationships for the caregiver
//         DocumentSnapshot relationshipSnapshot = await _firestore
//             .collection('relationships')
//             .doc(caregiverId)
//             .get();

//         if (relationshipSnapshot.exists) {
//           String assignedPatientId = relationshipSnapshot['patientId'];
//           return assignedPatientId;
//         } else {
//           return caregiverSnapshot;
//         }
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error checking caregiver ID: $e');
//       return null;
//     }
//   }

//   Future<DocumentSnapshot> _getPatientDataById(String patientId) async {
//     try {
//       return await _firestore.collection('users').doc(patientId).get();
//     } catch (e) {
//       print('Error getting patient data: $e');
//       rethrow;
//     }
//   }

//   Future<void> _createRelationship(
//     String caregiverId,
//     String patientId,
//     String currentUID,
//     String caregiverUserName,
//     String patientUserName,
//   ) async {
//     try {
//       await _firestore.collection('relationships').doc(caregiverId).set({
//         'patientId': patientId,
//         'caregiverId': caregiverId,
//         'currentUID': currentUID,
//         'caregiverUserName': caregiverUserName,
//         'patientUserName': patientUserName,
//       });

//       print('Relationship created successfully!');
//     } catch (e) {
//       print('Error creating relationship: $e');
//     }
//   }

//  Future<void> _verifyCaregiver() async {
//   setState(() {
//     _isLoading = true;
//   });

//   if (_isValidCaregiverID) {
//     String caregiverId = _caregiverIdController.text;
//     String patientId = _auth.currentUser!.uid;

//     dynamic caregiverDataOrPatientId =
//         await _getCaregiverDataById(caregiverId);

//     if (caregiverDataOrPatientId is DocumentSnapshot) {
//       // If caregiverDataOrPatientId is a DocumentSnapshot, it means this caregiver is not assigned to another patient
//       caregiverUid = caregiverDataOrPatientId.id;
//       caregiverName = caregiverDataOrPatientId['userName'];

//       // Fetch the patient (current user) username
//       DocumentSnapshot patientDoc = await _getPatientDataById(patientId);
//       String patientUserName = patientDoc['userName'];

//       await _createRelationship(
//         caregiverId,
//         patientId,
//         caregiverUid,
//         caregiverName,
//         patientUserName, // Use patientUserName here
//       );

//       // Save the caregiver ID to SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('caregiverId', caregiverId);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('You are now in relation with the caregiver'),
//           duration: Duration(seconds: 3),
//         ),
//       );

//       Future.delayed(const Duration(seconds: 3), () {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => PatientHomeScreen(
//               caregiverId: caregiverId,
//             ),
//           ),
//         );
//       });
//     } else if (caregiverDataOrPatientId is String) {
//       // If caregiverDataOrPatientId is a String, it means the caregiver is assigned to another patient
//       if (caregiverDataOrPatientId == patientId) {
//         // Allow access if the current user is the assigned patient
//         await _createRelationship(
//           caregiverId,
//           patientId,
//           caregiverId,
//           caregiverName,
//           patientUserName, // Use patientUserName here
//         );

//         // Save the caregiver ID to SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('caregiverId', caregiverId);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('You are now in relation with the caregiver'),
//             duration: Duration(seconds: 3),
//           ),
//         );

//         Future.delayed(const Duration(seconds: 3), () {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) => PatientHomeScreen(
//                 caregiverId: caregiverId,
//               ),
//             ),
//           );
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Caregiver is already assigned to another patient.'),
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Invalid caregiver ID. Please enter a valid ID.'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Invalid caregiver ID. Please enter a valid ID.'),
//         duration: Duration(seconds: 3),
//       ),
//     );
//     setState(() {
//       _isLoading = false;
//     });
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//             Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color.fromARGB(255, 38, 142, 226),
//                     Colors.white,
//                   ],
//                 ),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.only(top: 60.0, left: 22),
//                 child: Text(
//                   'Confirm\nCaregivers',
//                   style: TextStyle(
//                     fontSize: 30,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 200.0),
//               child: Center(
//                 child: Container(
//                   constraints:
//                       const BoxConstraints(minWidth: 300, maxWidth: 600),
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40),
//                     ),
//                     color: Colors.white,
//                   ),
//                   height: double.infinity,
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 18.0, right: 18),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextFormFieldWidget(
//                           controller: _caregiverIdController,
//                           keyboardType: TextInputType.number,
//                           onChanged: (value) {
//                             setState(() {
//                               _isValidCaregiverID = validateCaregiverId(value);
//                             });
//                           },
//                           suffixIcon: Icon(
//                             Icons.check,
//                             color: _isValidCaregiverID
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                           fieldName: 'Caregiver ID',
//                           obscureText: false,
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         GestureDetector(
//                           onTap: _verifyCaregiver,
//                           child: Container(
//                             height: 55,
//                             width: 300,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               gradient: const LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Color.fromARGB(255, 38, 142, 226),
//                                   Color.fromARGB(255, 38, 142, 226),
//                                 ],
//                               ),
//                             ),
//                             child: _isLoading
//                                 ? const Center(
//                                     child: Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: LoadingIndicator(
//                                         indicatorType: Indicator.lineScale,
//                                         colors: [Colors.white],
//                                         strokeWidth: 0.5,
//                                         backgroundColor: Colors.transparent,
//                                       ),
//                                     ),
//                                   )
//                                 : const Center(
//                                     child: Text(
//                                       'Verify',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
// import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart';

// class CaregiverRelationScreen extends StatefulWidget {
//   const CaregiverRelationScreen({super.key});

//   @override
//   _CaregiverRelationScreenState createState() =>
//       _CaregiverRelationScreenState();
// }

// class _CaregiverRelationScreenState extends State<CaregiverRelationScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   final TextEditingController _caregiverIdController = TextEditingController();
//   bool _isLoading = false;
//   bool _isValidCaregiverID = false;
//   String? caregiverUid;
//   String? caregiverName;
//   String? _savedCaregiverId;

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedCaregiverId();
//   }

//   Future<void> _loadSavedCaregiverId() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _savedCaregiverId = prefs.getString('caregiverId');
//       if (_savedCaregiverId != null) {
//         _caregiverIdController.text = _savedCaregiverId!;
//         _isValidCaregiverID = validateCaregiverId(_savedCaregiverId!);
//       }
//     });
//   }

//   bool validateCaregiverId(String caregiverId) {
//     RegExp caregiverIdRegex = RegExp(r'^\d{2,4}$');
//     return caregiverIdRegex.hasMatch(caregiverId);
//   }

//   Future<dynamic> _getCaregiverDataById(String caregiverId) async {
//     try {
//       // Fetch caregiver data
//       DocumentSnapshot caregiverSnapshot =
//           await _firestore.collection('users').doc(caregiverId).get();

//       if (caregiverSnapshot.exists) {
//         // Fetch existing relationships for the caregiver
//         DocumentSnapshot relationshipSnapshot =
//             await _firestore.collection('relationships').doc(caregiverId).get();

//         if (relationshipSnapshot.exists) {
//           String assignedPatientId = relationshipSnapshot['patientId'];
//           return assignedPatientId;
//         } else {
//           return caregiverSnapshot;
//         }
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error checking caregiver ID: $e');
//       return null;
//     }
//   }

//   Future<DocumentSnapshot> _getPatientDataById(String patientId) async {
//     try {
//       return await _firestore.collection('users').doc(patientId).get();
//     } catch (e) {
//       print('Error getting patient data: $e');
//       rethrow;
//     }
//   }

//   Future<void> _createRelationship(
//     String caregiverId,
//     String patientId,
//     String currentUID,
//     String caregiverUserName,
//     String patientUserName,
//   ) async {
//     try {
//       await _firestore.collection('relationships').doc(caregiverId).set({
//         'patientId': patientId,
//         'caregiverId': caregiverId,
//         'currentUID': currentUID,
//         'caregiverUserName': caregiverUserName,
//         'patientUserName': patientUserName,
//       });

//       print('Relationship created successfully!');
//     } catch (e) {
//       print('Error creating relationship: $e');
//     }
//   }

//   Future<void> _verifyCaregiver() async {
//     setState(() {
//       _isLoading = true;
//     });

//     if (_isValidCaregiverID) {
//       String caregiverId = _caregiverIdController.text;
//       String patientId = _auth.currentUser!.uid;

//       dynamic caregiverDataOrPatientId =
//           await _getCaregiverDataById(caregiverId);

//       if (caregiverDataOrPatientId is DocumentSnapshot) {
//         // If caregiverDataOrPatientId is a DocumentSnapshot, it means this caregiver is not assigned to another patient
//         caregiverUid = caregiverDataOrPatientId.id;
//         caregiverName = caregiverDataOrPatientId['userName'];

//         // Fetch the patient (current user) username
//         DocumentSnapshot patientDoc = await _getPatientDataById(patientId);
//         String patientUserName = patientDoc['patientUserName'];

//         await _createRelationship(
//           caregiverId,
//           patientId,
//           caregiverUid!,
//           caregiverName!,
//           patientUserName, // Use patientUserName here
//         );

//         // Save the caregiver ID to SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('caregiverId', caregiverId);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('You are now in relation with the caregiver'),
//             duration: Duration(seconds: 3),
//           ),
//         );

//         Future.delayed(const Duration(seconds: 3), () {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) => PatientHomeScreen(
//                 caregiverId: caregiverId,
//               ),
//             ),
//           );
//         });
//       } else if (caregiverDataOrPatientId is String) {
//         // If caregiverDataOrPatientId is a String, it means the caregiver is assigned to another patient
//         if (caregiverDataOrPatientId == patientId) {
//           // Allow access if the current user is the assigned patient
//           await _createRelationship(
//             caregiverId,
//             patientId,
//             caregiverId, // Use caregiverId here to indicate the relationship
//             caregiverName ?? '', // Ensure caregiverName is not null
//             await _getPatientDataById(patientId)
//                 .then((doc) => doc['userName']), // Fetch patient username again
//           );

// // Save the caregiver ID to SharedPreferences
// final prefs = await SharedPreferences.getInstance();
// await prefs.setString('caregiverId', caregiverId);

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('You are now in relation with the caregiver'),
//               duration: Duration(seconds: 3),
//             ),
//           );

//           Future.delayed(const Duration(seconds: 3), () {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(
//                 builder: (context) => PatientHomeScreen(
//                   caregiverId: caregiverId,
//                 ),
//               ),
//             );
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content:
//                   Text('Caregiver is already assigned to another patient.'),
//               duration: Duration(seconds: 3),
//             ),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Invalid caregiver ID. Please enter a valid ID.'),
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }

//       setState(() {
//         _isLoading = false;
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Invalid caregiver ID. Please enter a valid ID.'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//             Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color.fromARGB(255, 38, 142, 226),
//                     Colors.white,
//                   ],
//                 ),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.only(top: 60.0, left: 22),
//                 child: Text(
//                   'Confirm\nCaregivers',
//                   style: TextStyle(
//                     fontSize: 30,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 200.0),
//               child: Center(
//                 child: Container(
//                   constraints:
//                       const BoxConstraints(minWidth: 300, maxWidth: 600),
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40),
//                     ),
//                     color: Colors.white,
//                   ),
//                   height: double.infinity,
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 18.0, right: 18),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextFormFieldWidget(
//                           controller: _caregiverIdController,
//                           keyboardType: TextInputType.number,
//                           onChanged: (value) {
//                             setState(() {
//                               _isValidCaregiverID = validateCaregiverId(value);
//                             });
//                           },
//                           suffixIcon: Icon(
//                             Icons.check,
//                             color: _isValidCaregiverID
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                           fieldName: 'Caregiver ID',
//                           obscureText: false,
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         GestureDetector(
//                           onTap: _verifyCaregiver,
//                           child: Container(
//                             height: 55,
//                             width: 300,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               gradient: const LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Color.fromARGB(255, 38, 142, 226),
//                                   Color.fromARGB(255, 38, 142, 226),
//                                 ],
//                               ),
//                             ),
//                             child: _isLoading
//                                 ? const Center(
//                                     child: Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: LoadingIndicator(
//                                         indicatorType: Indicator.lineScale,
//                                         colors: [Colors.white],
//                                         strokeWidth: 0.5,
//                                         backgroundColor: Colors.transparent,
//                                       ),
//                                     ),
//                                   )
//                                 : const Center(
//                                     child: Text(
//                                       'Verify',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
// import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart';

// class CaregiverRelationScreen extends StatefulWidget {
//   const CaregiverRelationScreen({super.key});

//   @override
//   _CaregiverRelationScreenState createState() =>
//       _CaregiverRelationScreenState();
// }

// class _CaregiverRelationScreenState extends State<CaregiverRelationScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   final TextEditingController _caregiverIdController = TextEditingController();
//   bool _isLoading = false;
//   bool _isValidCaregiverID = false;
//   String? caregiverUid;
//   String? caregiverName;
//   String? _savedCaregiverId;

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedCaregiverId();
//   }

//   Future<void> _loadSavedCaregiverId() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _savedCaregiverId = prefs.getString('caregiverId');
//       if (_savedCaregiverId != null) {
//         _caregiverIdController.text = _savedCaregiverId!;
//         _isValidCaregiverID = validateCaregiverId(_savedCaregiverId!);
//       }
//     });
//   }

//   bool validateCaregiverId(String caregiverId) {
//     RegExp caregiverIdRegex = RegExp(r'^\d{2,4}$');
//     bool isValid = caregiverIdRegex.hasMatch(caregiverId);
//     log('Caregiver ID: $caregiverId, Is Valid: $isValid'); // Debug statement
//     return isValid;
//   }

//   Future<dynamic> _getCaregiverDataById(String caregiverId) async {
//     try {
//       // Fetch caregiver data
//       DocumentSnapshot caregiverSnapshot =
//           await _firestore.collection('users').doc(caregiverId).get();

//       if (caregiverSnapshot.exists) {
//         // Fetch existing relationships for the caregiver
//         DocumentSnapshot relationshipSnapshot =
//             await _firestore.collection('relationships').doc(caregiverId).get();

//         if (relationshipSnapshot.exists) {
//           String assignedPatientId = relationshipSnapshot['patientId'];
//           return assignedPatientId;
//         } else {
//           return caregiverSnapshot;
//         }
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error checking caregiver ID: $e');
//       return null;
//     }
//   }

//   Future<DocumentSnapshot> _getPatientDataById(String patientId) async {
//     try {
//       return await _firestore.collection('users').doc(patientId).get();
//     } catch (e) {
//       print('Error getting patient data: $e');
//       rethrow;
//     }
//   }

//   Future<void> _createRelationship(
//     String caregiverId,
//     String patientId,
//     String currentUID,
//     String caregiverUserName,
//     String patientUserName,
//   ) async {
//     try {
//       await _firestore.collection('relationships').doc(caregiverId).set({
//         'patientId': patientId,
//         'caregiverId': caregiverId,
//         'currentUID': currentUID,
//         'caregiverUserName': caregiverUserName,
//         'patientUserName': patientUserName,
//       });

//       print('Relationship created successfully!');
//     } catch (e) {
//       print('Error creating relationship: $e');
//     }
//   }

//   Future<void> _verifyCaregiver() async {
//     setState(() {
//       _isLoading = true;
//     });

//     if (_isValidCaregiverID) {
//       String caregiverId = _caregiverIdController.text;
//       String patientId = _auth.currentUser!.uid;

//       dynamic caregiverDataOrPatientId =
//           await _getCaregiverDataById(caregiverId);

//       if (caregiverDataOrPatientId is DocumentSnapshot) {
//         // If caregiverDataOrPatientId is a DocumentSnapshot, it means this caregiver is not assigned to another patient
//         caregiverUid = caregiverDataOrPatientId.id;
//         caregiverName = caregiverDataOrPatientId['userName'];

//         // Fetch the patient (current user) username
//         DocumentSnapshot patientDoc = await _getPatientDataById(patientId);
//         String patientUserName = patientDoc['userName'];

//         await _createRelationship(
//           caregiverId,
//           patientId,
//           caregiverUid!,
//           caregiverName!,
//           patientUserName, // Use patientUserName here
//         );

//         // Save the caregiver ID to SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('caregiverId', caregiverId);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('You are now in relation with the caregiver'),
//             duration: Duration(seconds: 3),
//           ),
//         );

//         Future.delayed(const Duration(seconds: 3), () {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) => PatientHomeScreen(
//                 caregiverId: caregiverId,
//               ),
//             ),
//           );
//         });
//       } else if (caregiverDataOrPatientId is String) {
//         // If caregiverDataOrPatientId is a String, it means the caregiver is assigned to another patient
//         if (caregiverDataOrPatientId == patientId) {
//           // Allow access if the current user is the assigned patient
//           await _createRelationship(
//             caregiverId,
//             patientId,
//             caregiverId, // Use caregiverId here to indicate the relationship
//             caregiverName ?? '', // Ensure caregiverName is not null
//             await _getPatientDataById(patientId)
//                 .then((doc) => doc['userName']), // Fetch patient username again
//           );

//           // Save the caregiver ID to SharedPreferences
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('caregiverId', caregiverId);

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('You are now in relation with the caregiver'),
//               duration: Duration(seconds: 3),
//             ),
//           );

//           Future.delayed(const Duration(seconds: 3), () {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(
//                 builder: (context) => PatientHomeScreen(
//                   caregiverId: caregiverId,
//                 ),
//               ),
//             );
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content:
//                   Text('Caregiver is already assigned to another patient.'),
//               duration: Duration(seconds: 3),
//             ),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Invalid caregiver ID. Please enter a valid ID.'),
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }

//       setState(() {
//         _isLoading = false;
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Invalid caregiver ID. Please enter a valid ID.'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//             Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color.fromARGB(255, 38, 142, 226),
//                     Colors.white,
//                   ],
//                 ),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.only(top: 60.0, left: 22),
//                 child: Text(
//                   'Confirm\nCaregivers',
//                   style: TextStyle(
//                     fontSize: 30,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 200.0),
//               child: Center(
//                 child: Container(
//                   constraints:
//                       const BoxConstraints(minWidth: 300, maxWidth: 600),
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40),
//                     ),
//                     color: Colors.white,
//                   ),
//                   height: double.infinity,
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 18.0, right: 18),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextFormFieldWidget(
//                           controller: _caregiverIdController,
//                           keyboardType: TextInputType.number,
//                           onChanged: (value) {
//                             setState(() {
//                               _isValidCaregiverID = validateCaregiverId(value);
//                             });
//                           },
//                           suffixIcon: Icon(
//                             Icons.check,
//                             color: _isValidCaregiverID
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                           fieldName: 'Caregiver ID',
//                           obscureText: false,
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         GestureDetector(
//                           onTap: _verifyCaregiver,
//                           child: Container(
//                             height: 55,
//                             width: 300,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               gradient: const LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Color.fromARGB(255, 38, 142, 226),
//                                   Color.fromARGB(255, 38, 142, 226),
//                                 ],
//                               ),
//                             ),
//                             child: _isLoading
//                                 ? const Center(
//                                     child: Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: LoadingIndicator(
//                                         indicatorType: Indicator.lineScale,
//                                         colors: [Colors.white],
//                                         strokeWidth: 0.5,
//                                         backgroundColor: Colors.transparent,
//                                       ),
//                                     ),
//                                   )
//                                 : const Center(
//                                     child: Text(
//                                       'Verify',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';
import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart';

class CaregiverRelationScreen extends StatefulWidget {
  const CaregiverRelationScreen({super.key});

  @override
  _CaregiverRelationScreenState createState() =>
      _CaregiverRelationScreenState();
}

class _CaregiverRelationScreenState extends State<CaregiverRelationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _caregiverIdController = TextEditingController();
  bool _isLoading = false;
  bool _isValidCaregiverID = false;
  String? _savedCaregiverId;

  @override
  void initState() {
    super.initState();
    _loadSavedCaregiverId();
  }

  Future<void> _loadSavedCaregiverId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedCaregiverId = prefs.getString('caregiverId');
      if (_savedCaregiverId != null) {
        _caregiverIdController.text = _savedCaregiverId!;
        _isValidCaregiverID = validateCaregiverId(_savedCaregiverId!);
      }
    });
  }

  bool validateCaregiverId(String caregiverId) {
    RegExp caregiverIdRegex = RegExp(r'^\d{2,4}$');
    return caregiverIdRegex.hasMatch(caregiverId);
  }

  Future<bool> _isCaregiverAssigned(
      String caregiverId, String patientId) async {
    try {
      DocumentSnapshot relationshipSnapshot =
          await _firestore.collection('relationships').doc(caregiverId).get();

      if (relationshipSnapshot.exists) {
        String assignedPatientId = relationshipSnapshot['patientId'];
        return assignedPatientId == patientId;
      }
      return false;
    } catch (e) {
      print('Error checking caregiver assignment: $e');
      return false;
    }
  }

  Future<DocumentSnapshot?> _getCaregiverDataById(String caregiverId) async {
    try {
      DocumentSnapshot caregiverSnapshot =
          await _firestore.collection('users').doc(caregiverId).get();

      if (caregiverSnapshot.exists) {
        return caregiverSnapshot;
      } else {
        return null;
      }
    } catch (e) {
      print('Error checking caregiver ID: $e');
      return null;
    }
  }

  Future<DocumentSnapshot> _getPatientDataById(String patientId) async {
    try {
      return await _firestore.collection('users').doc(patientId).get();
    } catch (e) {
      print('Error getting patient data: $e');
      rethrow;
    }
  }

  Future<void> _createRelationship(
    String caregiverId,
    String patientId,
    String caregiverUserName,
    String patientUserName,
  ) async {
    try {
      await _firestore.collection('relationships').doc(caregiverId).set({
        'patientId': patientId,
        'caregiverId': caregiverId,
        'caregiverUserName': caregiverUserName,
        'patientUserName': patientUserName,
      });

      print('Relationship created successfully!');
    } catch (e) {
      print('Error creating relationship: $e');
    }
  }

  Future<void> _verifyCaregiver() async {
    setState(() {
      _isLoading = true;
    });

    if (_isValidCaregiverID) {
      String caregiverId = _caregiverIdController.text;
      String patientId = _auth.currentUser!.uid;

      // Check if the patient is already assigned to the caregiver
      bool isAssigned = await _isCaregiverAssigned(caregiverId, patientId);

      if (isAssigned) {
        // If assigned, navigate to the home screen

        // Save the caregiver ID to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('caregiverId', caregiverId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You are already in relation with this caregiver.'),
            duration: Duration(seconds: 3),
          ),
        );

        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PatientHomeScreen(
                caregiverId: caregiverId,
              ),
            ),
          );
        });
      } else {
        // If not assigned, check if caregiver ID is valid
        DocumentSnapshot? caregiverData =
            await _getCaregiverDataById(caregiverId);

        if (caregiverData != null) {
          // Fetch the patient (current user) username
          DocumentSnapshot patientDoc = await _getPatientDataById(patientId);
          String patientUserName = patientDoc['userName'];
          String caregiverUserName = caregiverData['userName'];

          // Create a new relationship
          await _createRelationship(
            caregiverId,
            patientId,
            caregiverUserName,
            patientUserName,
          );

          // Save the caregiver ID to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('caregiverId', caregiverId);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are now in relation with the caregiver'),
              duration: Duration(seconds: 3),
            ),
          );

          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => PatientHomeScreen(
                  caregiverId: caregiverId,
                ),
              ),
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid caregiver ID. Please enter a valid ID.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid caregiver ID. Please enter a valid ID.'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
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
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 38, 142, 226),
                    Colors.white,
                  ],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Confirm\nCaregivers',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
                      topRight: Radius.circular(40),
                    ),
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
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _isValidCaregiverID = validateCaregiverId(value);
                            });
                          },
                          suffixIcon: Icon(
                            Icons.check,
                            color: _isValidCaregiverID
                                ? Colors.green
                                : Colors.grey,
                          ),
                          fieldName: 'Caregiver ID',
                          obscureText: false,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: _verifyCaregiver,
                          child: Container(
                            height: 55,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(255, 38, 142, 226),
                                  Color.fromARGB(255, 38, 142, 226),
                                ],
                              ),
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
                                        color: Colors.white,
                                      ),
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
