import 'package:ansan/util/patients/patient_test_result.dart';
import 'package:flutter/material.dart';

class UserPatientTestResultScreen extends StatefulWidget {
  const UserPatientTestResultScreen({
    super.key,
    required this.userData,
    required this.patientData,
    required this.reportId,
  });

  final Map<String, dynamic> userData, patientData;
  final String reportId;

  @override
  State<UserPatientTestResultScreen> createState() =>
      _UserPatientTestResultScreenState();
}

class _UserPatientTestResultScreenState
    extends State<UserPatientTestResultScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTestResultScreen(
      userData: widget.userData,
      patientData: widget.patientData,
      reportId: widget.reportId,
    );
  }
}
