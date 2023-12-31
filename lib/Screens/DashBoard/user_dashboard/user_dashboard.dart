// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
      ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: _firestore.collection('users').doc(_user.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error loading user data'),
              );
            } else {
              // Data retrieved successfully
              Map<String, dynamic>? userData =
                  snapshot.data?.data() as Map<String, dynamic>?;

              // Now you can use userData to display information on your dashboard
              // For example:
              String userName = userData?['userName'] ?? '';
              String email = userData?['email'] ?? '';
              String role = userData?['role'] ?? '';
              String userId = userData?['userId'] ?? '';

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('User Name: $userName'),
                  Text('Email: $email'),
                  Text('Role: $role'),
                  Text('User ID: $userId'),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
