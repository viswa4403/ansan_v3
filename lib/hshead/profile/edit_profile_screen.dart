import 'package:ansan/util/profile/edit_profile_screen.dart';
import 'package:flutter/material.dart';

class HsHeadEditProfileScreen extends StatefulWidget {
  const HsHeadEditProfileScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<HsHeadEditProfileScreen> createState() => _HsHeadEditProfileScreenState();
}

class _HsHeadEditProfileScreenState extends State<HsHeadEditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return EditProfileScreen(userData: widget.userData);
  }
}
