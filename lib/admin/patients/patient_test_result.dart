import 'package:ansan/util/patients/patient_test_result.dart';
import 'package:flutter/material.dart';

class AdminPatientTestResultScreen extends StatefulWidget {
  const AdminPatientTestResultScreen(
      {super.key,
      required this.userData,
      required this.patientData,
      required this.reportId});

  final Map<String, dynamic> userData, patientData;
  final String reportId;

  @override
  State<AdminPatientTestResultScreen> createState() =>
      _AdminPatientTestResultScreenState();
}

class _AdminPatientTestResultScreenState
    extends State<AdminPatientTestResultScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTestResultScreen(
      userData: widget.userData,
      patientData: widget.patientData,
      reportId: widget.reportId,
    );
  }
}
