import 'package:ansan/util/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class FrontlineWorkerProfileScreen extends StatefulWidget {
  const FrontlineWorkerProfileScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<FrontlineWorkerProfileScreen> createState() => _FrontlineWorkerProfileScreenState();
}

class _FrontlineWorkerProfileScreenState extends State<FrontlineWorkerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ProfileScreen(userData: widget.userData);
  }
}
