import 'package:ansan/util/patients/patient_take_test.dart';
import 'package:flutter/material.dart';

class HsHeadPatientTakeTestScreen extends StatefulWidget {
  const HsHeadPatientTakeTestScreen({super.key, required this.userData, required this.patientId});

  final Map<String, dynamic> userData;
  final String patientId;

  @override
  State<HsHeadPatientTakeTestScreen> createState() => _HsHeadPatientTakeTestScreenState();
}

class _HsHeadPatientTakeTestScreenState extends State<HsHeadPatientTakeTestScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTakeTest(userData: widget.userData, patientId: widget.patientId);
  }
}
