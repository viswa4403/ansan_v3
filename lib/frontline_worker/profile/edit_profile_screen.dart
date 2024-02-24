import 'package:ansan/util/profile/edit_profile_screen.dart';
import 'package:flutter/material.dart';

class FrontlineWorkerEditProfileScreen extends StatefulWidget {
  const FrontlineWorkerEditProfileScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<FrontlineWorkerEditProfileScreen> createState() => _FrontlineWorkerEditProfileScreenState();
}

class _FrontlineWorkerEditProfileScreenState extends State<FrontlineWorkerEditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return EditProfileScreen(userData: widget.userData);
  }
}
