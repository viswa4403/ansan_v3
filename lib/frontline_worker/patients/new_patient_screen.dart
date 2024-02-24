import 'package:ansan/util/patients/new_patient_screen.dart';
import 'package:flutter/material.dart';

class FrontlineWorkerNewPatientScreen extends StatefulWidget {
  const FrontlineWorkerNewPatientScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<FrontlineWorkerNewPatientScreen> createState() => _FrontlineWorkerNewPatientScreenState();
}

class _FrontlineWorkerNewPatientScreenState extends State<FrontlineWorkerNewPatientScreen> {
  @override
  Widget build(BuildContext context) {
    return NewPatientScreen(userData: widget.userData);
  }
}
