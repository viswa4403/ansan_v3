import 'package:ansan/util/patients/patient_test_result.dart';
import 'package:flutter/material.dart';

class DoctorPatientTestResultScreen extends StatefulWidget {
  const DoctorPatientTestResultScreen(
      {super.key,
      required this.userData,
      required this.patientData,
      required this.reportId});

  final Map<String, dynamic> userData, patientData;
  final String reportId;

  @override
  State<DoctorPatientTestResultScreen> createState() =>
      _DoctorPatientTestResultScreenState();
}

class _DoctorPatientTestResultScreenState
    extends State<DoctorPatientTestResultScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTestResultScreen(
      userData: widget.userData,
      patientData: widget.patientData,
      reportId: widget.reportId,
    );
  }
}
