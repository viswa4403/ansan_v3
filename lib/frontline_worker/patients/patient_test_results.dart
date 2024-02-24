import 'package:ansan/util/patients/patient_test_results.dart';
import 'package:flutter/material.dart';

class FrontlineWorkerPatientTestResultsScreen extends StatefulWidget {
  const FrontlineWorkerPatientTestResultsScreen(
      {super.key, required this.userData, required this.patientData});

  final Map<String, dynamic> userData, patientData;

  @override
  State<FrontlineWorkerPatientTestResultsScreen> createState() =>
      _FrontlineWorkerPatientTestResultsScreenState();
}

class _FrontlineWorkerPatientTestResultsScreenState
    extends State<FrontlineWorkerPatientTestResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTestResults(
      patientData: widget.patientData,
      userData: widget.userData,
    );
  }
}
