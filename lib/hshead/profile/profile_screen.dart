import 'package:ansan/util/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class HsHeadProfileScreen extends StatefulWidget {
  const HsHeadProfileScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<HsHeadProfileScreen> createState() => _HsHeadProfileScreenState();
}

class _HsHeadProfileScreenState extends State<HsHeadProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ProfileScreen(userData: widget.userData);
  }
}
