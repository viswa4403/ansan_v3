import 'package:ansan/util/patients/patient_test_results.dart';
import 'package:flutter/material.dart';

class UserPatientTestResultsScreen extends StatefulWidget {
  const UserPatientTestResultsScreen(
      {super.key, required this.userData, required this.patientData});

  final Map<String, dynamic> userData, patientData;

  @override
  State<UserPatientTestResultsScreen> createState() =>
      _UserPatientTestResultsScreenState();
}

class _UserPatientTestResultsScreenState
    extends State<UserPatientTestResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTestResults(
      patientData: widget.patientData,
      userData: widget.userData,
    );
  }
}
