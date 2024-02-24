import 'package:ansan/util/patients/patient_take_test.dart';
import 'package:flutter/material.dart';

class FrontlineWorkerPatientTakeTestScreen extends StatefulWidget {
  const FrontlineWorkerPatientTakeTestScreen({super.key, required this.userData, required this.patientId});

  final Map<String, dynamic> userData;
  final String patientId;

  @override
  State<FrontlineWorkerPatientTakeTestScreen> createState() => _FrontlineWorkerPatientTakeTestScreenState();
}

class _FrontlineWorkerPatientTakeTestScreenState extends State<FrontlineWorkerPatientTakeTestScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTakeTest(userData: widget.userData, patientId: widget.patientId);
  }
}
