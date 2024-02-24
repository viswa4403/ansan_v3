import 'package:ansan/util/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ProfileScreen(userData: widget.userData);
  }
}
