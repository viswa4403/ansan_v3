import 'package:ansan/util/patients/patient_test_result.dart';
import 'package:flutter/material.dart';

class FrontlineWorkerPatientTestResultScreen extends StatefulWidget {
  const FrontlineWorkerPatientTestResultScreen(
      {super.key,
      required this.userData,
      required this.patientData,
      required this.reportId});

  final Map<String, dynamic> userData, patientData;
  final String reportId;

  @override
  State<FrontlineWorkerPatientTestResultScreen> createState() =>
      _FrontlineWorkerPatientTestResultScreenState();
}

class _FrontlineWorkerPatientTestResultScreenState
    extends State<FrontlineWorkerPatientTestResultScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTestResultScreen(
      userData: widget.userData,
      patientData: widget.patientData,
      reportId: widget.reportId,
    );
  }
}
