import 'package:ansan/util/patients/patient_test_results.dart';
import 'package:flutter/material.dart';

class HsHeadPatientTestResultsScreen extends StatefulWidget {
  const HsHeadPatientTestResultsScreen(
      {super.key, required this.userData, required this.patientData});

  final Map<String, dynamic> userData, patientData;

  @override
  State<HsHeadPatientTestResultsScreen> createState() =>
      _HsHeadPatientTestResultsScreenState();
}

class _HsHeadPatientTestResultsScreenState
    extends State<HsHeadPatientTestResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTestResults(
      patientData: widget.patientData,
      userData: widget.userData,
    );
  }
}
