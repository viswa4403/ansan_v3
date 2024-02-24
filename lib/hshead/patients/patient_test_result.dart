import 'package:ansan/util/patients/patient_test_result.dart';
import 'package:flutter/material.dart';

class HsHeadPatientTestResultScreen extends StatefulWidget {
  const HsHeadPatientTestResultScreen(
      {super.key,
      required this.userData,
      required this.patientData,
      required this.reportId});

  final Map<String, dynamic> userData, patientData;
  final String reportId;

  @override
  State<HsHeadPatientTestResultScreen> createState() =>
      _HsHeadPatientTestResultScreenState();
}

class _HsHeadPatientTestResultScreenState
    extends State<HsHeadPatientTestResultScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTestResultScreen(
      userData: widget.userData,
      patientData: widget.patientData,
      reportId: widget.reportId,
    );
  }
}
