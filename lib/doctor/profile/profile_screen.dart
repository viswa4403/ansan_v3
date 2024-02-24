import 'package:ansan/util/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ProfileScreen(userData: widget.userData);
  }
}
