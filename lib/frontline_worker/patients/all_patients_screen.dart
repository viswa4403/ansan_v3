import 'package:ansan/util/patients/all_patients_screen.dart';
import 'package:flutter/material.dart';

class FrontlineWorkerAllPatientsScreen extends StatefulWidget {
  const FrontlineWorkerAllPatientsScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<FrontlineWorkerAllPatientsScreen> createState() => _FrontlineWorkerAllPatientsScreenState();
}

class _FrontlineWorkerAllPatientsScreenState extends State<FrontlineWorkerAllPatientsScreen> {
  @override
  Widget build(BuildContext context) {
    return AllPatientsAddedByMeScreen(userData: widget.userData);
  }
}
