import 'package:flutter/material.dart';

class DashbaordScreen extends StatefulWidget {
  const DashbaordScreen({super.key});

  @override
  State<DashbaordScreen> createState() => _DashbaordScreenState();
}

class _DashbaordScreenState extends State<DashbaordScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Dashboard Screen')),
    );
  }
}
