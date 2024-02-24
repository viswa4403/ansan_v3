import 'package:ansan/util/patients/patient_test_results.dart';
import 'package:flutter/material.dart';

class DoctorPatientTestResultsScreen extends StatefulWidget {
  const DoctorPatientTestResultsScreen(
      {super.key, required this.userData, required this.patientData});

  final Map<String, dynamic> userData, patientData;

  @override
  State<DoctorPatientTestResultsScreen> createState() =>
      _DoctorPatientTestResultsScreenState();
}

class _DoctorPatientTestResultsScreenState
    extends State<DoctorPatientTestResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTestResults(
      patientData: widget.patientData,
      userData: widget.userData,
    );
  }
}
