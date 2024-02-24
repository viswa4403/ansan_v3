import 'package:ansan/util/patients/patient_test_results.dart';
import 'package:flutter/material.dart';

class AdminPatientTestResultsScreen extends StatefulWidget {
  const AdminPatientTestResultsScreen(
      {super.key, required this.userData, required this.patientData});

  final Map<String, dynamic> userData, patientData;

  @override
  State<AdminPatientTestResultsScreen> createState() =>
      _AdminPatientTestResultsScreenState();
}

class _AdminPatientTestResultsScreenState
    extends State<AdminPatientTestResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTestResults(
      patientData: widget.patientData,
      userData: widget.userData,
    );
  }
}
