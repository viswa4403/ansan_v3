import 'package:ansan/util/patients/patient_screen.dart';
import 'package:flutter/material.dart';

class FrontlineWorkerPatientScreen extends StatefulWidget {
  const FrontlineWorkerPatientScreen({super.key, required this.userData, required this.patientId});

  final Map<String, dynamic> userData;
  final String patientId;

  @override
  State<FrontlineWorkerPatientScreen> createState() => _FrontlineWorkerPatientScreenState();
}

class _FrontlineWorkerPatientScreenState extends State<FrontlineWorkerPatientScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewPatientScreen(patientId: widget.patientId, userData: widget.userData);
  }
}
