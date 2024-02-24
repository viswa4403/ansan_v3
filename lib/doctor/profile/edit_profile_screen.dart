import 'package:ansan/util/profile/edit_profile_screen.dart';
import 'package:flutter/material.dart';

class DoctorEditProfileScreen extends StatefulWidget {
  const DoctorEditProfileScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<DoctorEditProfileScreen> createState() => _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState extends State<DoctorEditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return EditProfileScreen(userData: widget.userData);
  }
}
